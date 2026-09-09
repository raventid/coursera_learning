// Typical rust runtime implementation skeleton


// 1. Waker, includes task_id and queueue

fn make_waker(task_id: usize, queue: std::sync::mpsc::Sender<usize>) -> std::task::Waker {
    use std::sync::{Arc};
    use std::sync::mpsc::{Sender};
    use std::task::{RawWaker, RawWakerVTable, Waker};

    let inner = (task_id, queue);
    let data = Arc::new(inner);

    // We build the whole Vtable by hand, because of clone is not object safe, so trait is not available for us :(
    unsafe fn clone(ptr: *const ()) -> RawWaker {
        let arc = Arc::<(usize, Sender<usize>)>::from_raw(ptr as *const _);
        let cloned = arc.clone();
        std::mem::forget(arc); // ??? check
        RawWaker::new(Arc::into_raw(cloned) as *const (), &VTABLE)
    }

    unsafe fn wake(ptr: *const ()) {
        let arc = Arc::<(usize, Sender<usize>)>::from_raw(ptr as *const _);
        arc.1.send(arc.0).ok();
    }

    unsafe fn wake_by_ref(ptr: *const ()) {
        let arc = Arc::<(usize, Sender<usize>)>::from_raw(ptr as *const _);
        let sender = &arc.1;
        let task_id = arc.0;
        sender.send(task_id).ok();
    }

    unsafe fn drop_fn(ptr: *const ()) {
        drop(Arc::<(usize, Sender<usize>)>::from_raw(ptr as *const _));
    }

    static VTABLE: RawWakerVTable = RawWakerVTable::new(clone, wake, wake_by_ref, drop_fn);

    let raw = RawWaker::new(Arc::into_raw(data) as *const (), &VTABLE);
    unsafe { Waker::from_raw(raw) }
}

// 2. Future - timer, wakes iself through the background thread
struct Timer {
    when: std::time::Instant,
    registered: bool,
    shared: std::sync::Arc<TimerThread>
}

impl Future for Timer {
    type Output = ();

    fn poll(mut self: std::pin::Pin<&mut Self>, cx: &mut std::task::Context<'_>) -> std::task::Poll<()> {
        if std::time::Instant::now() >= self.when {
            return std::task::Poll::Ready(());
        }

        if !self.registered {
            self.registered = true;
            self.shared.add(self.when, cx.waker().clone());
        }

        std::task::Poll::Pending
    }
}

// 3. Usually event loop needs a reactor part that wakes up the future, when something happens / mio/poller do this in tokio/smol
// In our case reactor could be a separate TimerThread (to detect a reactor part we just need to understand where waking up is triggered)
struct TimerThread {
    tx: std::sync::mpsc::Sender<(std::time::Instant, std::task::Waker)>
}

impl TimerThread {
    fn start() -> std::sync::Arc<Self> {
        let (tx, rx) = std::sync::mpsc::channel::<(std::time::Instant, std::task::Waker)>();

        std::thread::spawn(move || {
            let mut pending: Vec<(std::time::Instant, std::task::Waker)> = Vec::new();

            loop {
                while let Ok(item) = rx.try_recv() {
                    pending.push(item);
                }

                let now = std::time::Instant::now();
                pending.retain(|(when, waker)| {
                    if now >= *when {
                        waker.wake_by_ref();
                        false
                    } else {
                        true
                    }
                });

                std::thread::sleep(std::time::Duration::from_millis(1));
            }
        });

        std::sync::Arc::new(TimerThread { tx })
    }

    fn add(&self, when: std::time::Instant, waker: std::task::Waker) {
        let _ = self.tx.send((when, waker));
    }
}

// 4. Executor - second half of event loop
struct Executor {
    tasks: std::collections::HashMap<usize, std::pin::Pin<std::boxed::Box<dyn std::future::Future<Output = ()>>>>,
    rx: std::sync::mpsc::Receiver<usize>,
    tx: std::sync::mpsc::Sender<usize>,
    next: usize,
}

impl Executor {
    fn new() -> Self {
        let (tx, rx) = std::sync::mpsc::channel(); 
        Executor {
            tasks: std::collections::HashMap::new(),
            rx,
            tx,
            next: 0
        }
    }

    fn spawn(&mut self, f: impl std::future::Future<Output = ()> + 'static) {
        let id = self.next;
        self.next += 1;
        
        self.tasks.insert(id, std::boxed::Box::pin(f));
        let _ = self.tx.send(id);
    }

    fn run(&mut self) {
        while !self.tasks.is_empty() {
            let id = self.rx.recv().unwrap();
            let Some(task) = self.tasks.get_mut(&id) else { continue };

            let waker = make_waker(id, self.tx.clone());
            let mut cx = std::task::Context::from_waker(&waker);

            if task.as_mut().poll(&mut cx).is_ready() {
                self.tasks.remove(&id);
            }
        }
    }
}


fn main() {
    let timer = TimerThread::start();
    let mut ex = Executor::new();
    let counter = std::sync::Arc::new(std::sync::Mutex::new(0));

    for i in 0..100_000 {
        let timer = timer.clone();
        let counter = counter.clone();

        ex.spawn(async move {
            let ms = 50 + (i % 100) as u64;

            Timer { when: std::time::Instant::now() + std::time::Duration::from_millis(ms), registered: false, shared: timer }.await;

            *counter.lock().unwrap() += 1;
        });
    }

    let start = std::time::Instant::now();
    ex.run();
    println!("{} tasks finished, total time {:?} ", *counter.lock().unwrap(), start.elapsed());
}
