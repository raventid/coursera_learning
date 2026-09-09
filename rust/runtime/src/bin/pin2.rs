// Read through https://blog.yoshuawuyts.com/the-waker-allocation-problem/

// Are lifetimes only for reference types or not?
// Stack pinning, why? What if my future is fully on the stack, why should I pin it? (for example if no variant of state machine have heap allocated data)
// Wait, but how pin works, i.e. if I have array in one of the future states and array reallocates - it is still a realoc, I cannot stop it.
 
use std::future::Future;
use std::pin::Pin;
use std::sync::Arc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::task::{Context, Poll, Wake, Waker};
use std::option::Option;
use std::time::{Duration, Instant};

struct Join<Fut: Future, const N: usize> {
    futures: [Fut; N],
    outputs: [Option<Fut::Output>; N],
    /// One waker per child, created on first poll (it needs the parent waker).
    /// The child's "ready" flag lives inside the waker itself.
    wakers: [Option<Arc<ChildWaker>>; N],
}

/// A waker associated with a specific child future.
struct ChildWaker {
    ready: AtomicBool,
    parent: Waker,
}

impl Wake for ChildWaker {
    fn wake(self: Arc<Self>) {
        self.wake_by_ref();
    }

    fn wake_by_ref(self: &Arc<Self>) {
        self.ready.store(true, Ordering::Release);
        self.parent.wake_by_ref();
    }
}

impl <Fut: Future, const N: usize> Future for Join<Fut, N> {
    type Output = [Fut::Output; N];

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        let this = unsafe { self.get_unchecked_mut() };
        let mut all_done = true;

        // Each child gets its own waker that flips a "ready" flag for that
        // child, so we only poll the children that actually asked for it.
        // Every child starts ready; after that a child is polled once per wake.
        for i in 0..this.futures.len() {
            if this.outputs[i].is_some() {
                continue;
            }
            let waker = this.wakers[i].get_or_insert_with(|| {
                Arc::new(ChildWaker {
                    ready: AtomicBool::new(true),
                    parent: cx.waker().clone(),
                })
            });
            if !waker.ready.swap(false, Ordering::AcqRel) {
                all_done = false;
                continue;
            }

            let waker = Waker::from(waker.clone());
            let mut child_cx = Context::from_waker(&waker);

            let fut = unsafe { Pin::new_unchecked(&mut this.futures[i]) };
            match fut.poll(&mut child_cx) {
                Poll::Ready(output) => this.outputs[i] = Some(output),
                Poll::Pending => all_done = false,
            }
        }

        if !all_done {
            return Poll::Pending;
        }

        let outputs = std::mem::replace(&mut this.outputs, std::array::from_fn(|_| None)).map(Option::unwrap);

        Poll::Ready(outputs)
    }
}

/// A timer that is ready once its deadline has passed. On its first poll it
/// arranges to be woken at the deadline, so nobody needs to re-poll it before.
struct Timer {
    id: usize,
    deadline: Instant,
    polls: usize,
}

impl Future for Timer {
    type Output = usize;

    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<usize> {
        self.polls += 1;
        println!("  timer {} polled (poll #{})", self.id, self.polls);

        if Instant::now() >= self.deadline {
            Poll::Ready(self.polls)
        } else {
            // To avoid starting multiple background threads with notification we start reactor only on the first poll
            if self.polls == 1 {
                let waker = cx.waker().clone();
                let deadline = self.deadline;

                // We don't have a properly implemented reactor thread, so every future has to be a reactor itself, to notify executor
                std::thread::spawn(move || {
                    std::thread::sleep(deadline.saturating_duration_since(Instant::now()));
                    waker.wake();
                });
            }
            Poll::Pending
        }
    }
}

fn main() {
    let start = Instant::now();
    let deadline = start + Duration::from_secs(10);

    let join = Join {
        futures: std::array::from_fn(|i| Timer { id: i, deadline, polls: 0 }),
        outputs: [const { None }; 5],
        wakers: [const { None }; 5],
    };
    let mut join = std::pin::pin!(join);

    // Minimal "runtime": still sleeps and blindly re-polls the root every
    // second, but Join now forwards the poll only to children that were woken.
    let mut cx = Context::from_waker(Waker::noop());
    let mut rounds = 0;

    let polls = loop {
        rounds += 1;
        println!("round {rounds} at {:?}", start.elapsed());
        if let Poll::Ready(polls) = join.as_mut().poll(&mut cx) {
            break polls;
        }
        std::thread::sleep(Duration::from_secs(1));
    };

    let total: usize = polls.iter().sum();
    println!("done after {rounds} rounds and {total} child polls (5 initial + 5 woken)");
}
