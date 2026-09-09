// Thread-per-core runtime: N независимых ядер, у каждого свой executor,
// свой reactor (таймеры) и своё локальное состояние. Между ядрами — только сообщения.

use std::cell::RefCell;
use std::collections::{BTreeMap, HashMap};
use std::future::Future;
use std::pin::Pin;
use std::rc::Rc;
use std::sync::mpsc::{channel, Receiver, RecvTimeoutError, Sender};
use std::sync::{Arc, Mutex};
use std::task::{Context, Poll, Wake, Waker};
use std::time::{Duration, Instant};

// ---------------------------------------------------------------------------
// 1. События ядра. Один канал на ядро — это и очередь готовых задач,
//    и почтовый ящик для сообщений с других ядер.
// ---------------------------------------------------------------------------

type LocalFuture = Pin<Box<dyn Future<Output = ()>>>; // заметьте: без Send

enum Event {
    Wake(usize),                    // задача с таким id готова к poll
    Run(Box<dyn FnOnce() + Send>),  // «выполни это у себя» — от другого ядра
    Shutdown,
}

// ---------------------------------------------------------------------------
// 2. Waker. Вместо ручной vtable из прошлой статьи — std::task::Wake.
//    Waker обязан быть Send + Sync: его могут дёрнуть с другого ядра.
// ---------------------------------------------------------------------------

struct TaskWaker {
    id: usize,
    tx: Sender<Event>,
}

impl Wake for TaskWaker {
    fn wake(self: Arc<Self>) {
        self.wake_by_ref();
    }
    fn wake_by_ref(self: &Arc<Self>) {
        let _ = self.tx.send(Event::Wake(self.id));
    }
}

// ---------------------------------------------------------------------------
// 3. Handle — единственное, что видно снаружи ядра. Через него другие потоки
//    могут попросить ядро выполнить замыкание (и внутри — заспавнить задачу).
// ---------------------------------------------------------------------------

#[derive(Clone)]
struct Handle {
    tx: Sender<Event>,
}

impl Handle {
    fn run(&self, f: impl FnOnce() + Send + 'static) {
        let _ = self.tx.send(Event::Run(Box::new(f)));
    }
    fn shutdown(&self) {
        let _ = self.tx.send(Event::Shutdown);
    }
}

// ---------------------------------------------------------------------------
// 4. Thread-local контекст ядра: кто я, мои таймеры, моя очередь на spawn.
//    Всё в Rc — из другого потока сюда не добраться в принципе.
// ---------------------------------------------------------------------------

#[derive(Default)]
struct Timers {
    seq: u64,
    map: BTreeMap<(Instant, u64), Waker>,
}

#[derive(Clone)]
struct CoreCtx {
    id: usize,
    tx: Sender<Event>,
    timers: Rc<RefCell<Timers>>,
    spawn_q: Rc<RefCell<Vec<LocalFuture>>>,
}

thread_local! {
    static CURRENT: RefCell<Option<CoreCtx>> = const { RefCell::new(None) };
}

fn with_ctx<R>(f: impl FnOnce(&CoreCtx) -> R) -> R {
    CURRENT.with(|c| f(c.borrow().as_ref().expect("not on a core thread")))
}

fn core_id() -> usize {
    with_ctx(|c| c.id)
}

/// spawn без Send — главное отличие от tokio::spawn
fn spawn_local(f: impl Future<Output = ()> + 'static) {
    with_ctx(|c| c.spawn_q.borrow_mut().push(Box::pin(f)));
}

// ---------------------------------------------------------------------------
// 5. Ядро: executor + reactor в одном цикле. Когда нечего делать, поток
//    засыпает в recv_timeout до ближайшего таймера или до внешнего события.
// ---------------------------------------------------------------------------

struct Core {
    ctx: CoreCtx,
    rx: Receiver<Event>,
    tasks: HashMap<usize, LocalFuture>,
    next_id: usize,
}

impl Core {
    fn start(id: usize) -> (Handle, std::thread::JoinHandle<()>) {
        let (tx, rx) = channel();
        let handle = Handle { tx: tx.clone() };
        let join = std::thread::Builder::new()
            .name(format!("core-{id}"))
            .spawn(move || {
                let ctx = CoreCtx {
                    id,
                    tx,
                    timers: Rc::default(),
                    spawn_q: Rc::default(),
                };
                CURRENT.with(|c| *c.borrow_mut() = Some(ctx.clone()));
                Core { ctx, rx, tasks: HashMap::new(), next_id: 0 }.run();
            })
            .unwrap();
        (handle, join)
    }

    fn run(mut self) {
        loop {
            // --- reactor-часть: ждём событие, но не дольше ближайшего таймера
            let next_deadline = self.ctx.timers.borrow().map.keys().next().map(|k| k.0);
            let first = match next_deadline {
                Some(deadline) => {
                    let timeout = deadline.saturating_duration_since(Instant::now());
                    match self.rx.recv_timeout(timeout) {
                        Ok(ev) => Some(ev),
                        Err(RecvTimeoutError::Timeout) => None,
                        Err(RecvTimeoutError::Disconnected) => return,
                    }
                }
                None => match self.rx.recv() {
                    Ok(ev) => Some(ev),
                    Err(_) => return,
                },
            };

            // забираем всё, что уже накопилось, одной пачкой
            let mut batch: Vec<Event> = first.into_iter().collect();
            while let Ok(ev) = self.rx.try_recv() {
                batch.push(ev);
            }

            // --- executor-часть
            for ev in batch {
                match ev {
                    Event::Wake(id) => self.poll_task(id),
                    Event::Run(f) => f(),
                    Event::Shutdown => return,
                }
            }

            // --- истёкшие таймеры будят свои задачи (через тот же канал)
            let now = Instant::now();
            let mut timers = self.ctx.timers.borrow_mut();
            while let Some(entry) = timers.map.first_entry() {
                if entry.key().0 > now {
                    break;
                }
                entry.remove().wake();
            }
            drop(timers);

            // --- новые задачи, заспавненные во время poll
            let new: Vec<LocalFuture> = self.ctx.spawn_q.borrow_mut().drain(..).collect();
            for fut in new {
                let id = self.next_id;
                self.next_id += 1;
                self.tasks.insert(id, fut);
                let _ = self.ctx.tx.send(Event::Wake(id));
            }
        }
    }

    fn poll_task(&mut self, id: usize) {
        let Some(task) = self.tasks.get_mut(&id) else { return };
        let waker = Waker::from(Arc::new(TaskWaker { id, tx: self.ctx.tx.clone() }));
        let mut cx = Context::from_waker(&waker);
        if task.as_mut().poll(&mut cx).is_ready() {
            self.tasks.remove(&id);
        }
    }
}

// ---------------------------------------------------------------------------
// 6. Таймер. Регистрируется в reactor'е СВОЕГО ядра. Никаких Arc, никаких
//    фоновых потоков: reactor живёт в том же цикле, что и executor.
// ---------------------------------------------------------------------------

struct Sleep {
    when: Instant,
    registered: bool,
}

fn sleep(d: Duration) -> Sleep {
    Sleep { when: Instant::now() + d, registered: false }
}

impl Future for Sleep {
    type Output = ();
    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<()> {
        if Instant::now() >= self.when {
            return Poll::Ready(());
        }
        if !self.registered {
            self.registered = true;
            let when = self.when;
            let waker = cx.waker().clone();
            with_ctx(|c| {
                let mut t = c.timers.borrow_mut();
                t.seq += 1;
                let seq = t.seq;
                t.map.insert((when, seq), waker);
            });
        }
        Poll::Pending
    }
}

// ---------------------------------------------------------------------------
// 7. Oneshot: единственное место, где нужен Mutex — граница между ядрами.
// ---------------------------------------------------------------------------

struct Slot<T> {
    value: Option<T>,
    waker: Option<Waker>,
}

struct OneshotTx<T>(Arc<Mutex<Slot<T>>>);
struct OneshotRx<T>(Arc<Mutex<Slot<T>>>);

fn oneshot<T>() -> (OneshotTx<T>, OneshotRx<T>) {
    let slot = Arc::new(Mutex::new(Slot { value: None, waker: None }));
    (OneshotTx(slot.clone()), OneshotRx(slot))
}

impl<T> OneshotTx<T> {
    fn send(self, v: T) {
        let mut g = self.0.lock().unwrap();
        g.value = Some(v);
        let waker = g.waker.take();
        drop(g);
        if let Some(w) = waker {
            w.wake(); // это и есть «разбудить задачу на другом ядре»
        }
    }
}

impl<T> Future for OneshotRx<T> {
    type Output = T;
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<T> {
        let mut g = self.0.lock().unwrap();
        match g.value.take() {
            Some(v) => Poll::Ready(v),
            None => {
                g.waker = Some(cx.waker().clone());
                Poll::Pending
            }
        }
    }
}

// ---------------------------------------------------------------------------
// 8. Шардированное key-value хранилище. Каждое ядро владеет своим куском
//    ключевого пространства. Шард — обычный HashMap в thread_local, без Mutex.
// ---------------------------------------------------------------------------

thread_local! {
    static SHARD: RefCell<HashMap<u64, u64>> = RefCell::new(HashMap::new());
}

struct Cluster {
    cores: Vec<Handle>,
}

impl Cluster {
    fn owner(&self, key: u64) -> usize {
        (key % self.cores.len() as u64) as usize
    }

    async fn put(&self, key: u64, val: u64) -> Option<u64> {
        let owner = self.owner(key);
        if owner == core_id() {
            // быстрый путь: ключ наш, никакой синхронизации
            return SHARD.with(|s| s.borrow_mut().insert(key, val));
        }
        // медленный путь: просим владельца и ждём ответ
        let (tx, rx) = oneshot();
        self.cores[owner].run(move || {
            let old = SHARD.with(|s| s.borrow_mut().insert(key, val));
            tx.send(old);
        });
        rx.await
    }

    async fn get(&self, key: u64) -> Option<u64> {
        let owner = self.owner(key);
        if owner == core_id() {
            return SHARD.with(|s| s.borrow().get(&key).copied());
        }
        let (tx, rx) = oneshot();
        self.cores[owner].run(move || {
            tx.send(SHARD.with(|s| s.borrow().get(&key).copied()));
        });
        rx.await
    }
}

// ---------------------------------------------------------------------------
// 9. Демо: !Send-задачи и общение между ядрами
// ---------------------------------------------------------------------------

fn demo(cluster: &Arc<Cluster>) {
    let (done_tx, done_rx) = channel::<String>();

    // Задача на ядре 0 держит Rc<RefCell<..>> через .await — в tokio::spawn так нельзя.
    let dt = done_tx.clone();
    cluster.cores[0].run(move || {
        let log: Rc<RefCell<Vec<String>>> = Rc::default();
        for i in 0..3 {
            let log = log.clone();
            spawn_local(async move {
                sleep(Duration::from_millis(10 * (3 - i))).await;
                log.borrow_mut().push(format!("task {i} on core {}", core_id()));
            });
        }
        let dt = dt.clone();
        spawn_local(async move {
            sleep(Duration::from_millis(50)).await;
            dt.send(format!("core 0 log: {:?}", log.borrow())).unwrap();
        });
    });

    // Задача на ядре 1 пишет ключ, которым владеет другое ядро, и читает обратно.
    let c = cluster.clone();
    let dt = done_tx;
    cluster.cores[1].run(move || {
        spawn_local(async move {
            let key = 42;
            let owner = c.owner(key);
            c.put(key, 7).await;
            let v = c.get(key).await;
            dt.send(format!("core 1: key {key} lives on core {owner}, get -> {v:?}")).unwrap();
        });
    });

    for _ in 0..2 {
        println!("{}", done_rx.recv().unwrap());
    }
}

// ---------------------------------------------------------------------------
// 10. Бенчмарк: общий HashMap под Mutex против шардов
// ---------------------------------------------------------------------------

struct XorShift(u64);
impl XorShift {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }
}

const KEY_SPACE: u64 = 1 << 16;

fn bench(
    name: &str,
    cluster: &Arc<Cluster>,
    tasks_per_core: usize,
    ops_per_task: usize,
    make_task: impl Fn(usize, usize) -> Pin<Box<dyn Future<Output = ()> + Send>> + Send + Sync + 'static,
) {
    let n = cluster.cores.len();
    let (done_tx, done_rx) = channel::<()>();
    let make_task = Arc::new(make_task);

    let start = Instant::now();
    for (core, h) in cluster.cores.iter().enumerate() {
        let done_tx = done_tx.clone();
        let make_task = make_task.clone();
        h.run(move || {
            for t in 0..tasks_per_core {
                let fut = make_task(core, t);
                let done_tx = done_tx.clone();
                spawn_local(async move {
                    fut.await;
                    let _ = done_tx.send(());
                });
            }
        });
    }
    for _ in 0..n * tasks_per_core {
        done_rx.recv().unwrap();
    }
    let elapsed = start.elapsed();
    let ops = (n * tasks_per_core * ops_per_task) as f64;
    println!(
        "{name:<28} {:>8.1} ms   {:>6.1} Mops/s   {:>6.0} ns/op (wall)",
        elapsed.as_secs_f64() * 1e3,
        ops / elapsed.as_secs_f64() / 1e6,
        elapsed.as_nanos() as f64 / ops
    );
}

fn main() {
    let n = std::thread::available_parallelism().map(|n| n.get()).unwrap_or(4);
    let n = n.min(8);
    let (handles, joins): (Vec<_>, Vec<_>) = (0..n).map(Core::start).unzip();
    let cluster = Arc::new(Cluster { cores: handles });

    println!("--- demo on {n} cores ---");
    demo(&cluster);

    let tasks_per_core = 32;
    let ops_per_task = 20_000;
    println!(
        "\n--- bench: {n} cores x {tasks_per_core} tasks x {ops_per_task} ops, key space {KEY_SPACE} ---"
    );

    // A. Общее состояние: один HashMap под Mutex, как в типичном tokio-сервисе
    let shared: Arc<Mutex<HashMap<u64, u64>>> = Arc::default();
    let s = shared.clone();
    bench("shared Arc<Mutex<HashMap>>", &cluster, tasks_per_core, ops_per_task, move |core, t| {
        let s = s.clone();
        Box::pin(async move {
            let mut rng = XorShift(0x9E37_79B9_7F4A_7C15 ^ ((core * 1000 + t + 1) as u64));
            for i in 0..ops_per_task {
                let key = rng.next() % KEY_SPACE;
                let mut m = s.lock().unwrap();
                if i % 2 == 0 { m.insert(key, i as u64); } else { std::hint::black_box(m.get(&key)); }
            }
        })
    });

    // B. Шарды. Доля локальных ключей задаёт, как часто запрос уходит на чужое ядро.
    //    p = 1.0  — shard-aware клиент, всё локально
    //    p = 1/n  — ключи случайные, как если бы запросы приходили куда попало
    for &local_share in &[1.0_f64, 0.9, 0.5, 1.0 / n as f64] {
        let c = cluster.clone();
        let name = format!("sharded, {:.0}% local keys", local_share * 100.0);
        bench(&name, &cluster, tasks_per_core, ops_per_task, move |core, t| {
            let c = c.clone();
            Box::pin(async move {
                let n = c.cores.len() as u64;
                let mut rng = XorShift(0x9E37_79B9_7F4A_7C15 ^ ((core * 1000 + t + 1) as u64));
                let threshold = (local_share * u64::MAX as f64) as u64;
                for i in 0..ops_per_task {
                    let r = rng.next() % (KEY_SPACE / n);
                    let key = if rng.next() < threshold {
                        r * n + core as u64                      // свой шард
                    } else {
                        r * n + (core as u64 + 1 + rng.next() % (n - 1)) % n // чужой
                    };
                    if i % 2 == 0 { c.put(key, i as u64).await; } else { std::hint::black_box(c.get(key).await); }
                }
            })
        });
    }

    for h in &cluster.cores {
        h.shutdown();
    }
    for j in joins {
        j.join().unwrap();
    }
}
