// Read through https://blog.yoshuawuyts.com/the-waker-allocation-problem/

// Are lifetimes only for reference types or not?
// Stack pinning, why? What if my future is fully on the stack, why should I pin it? (for example if no variant of state machine have heap allocated data)
// Wait, but how pin works, i.e. if I have array in one of the future states and array reallocates - it is still a realoc, I cannot stop it.
 
use std::future::Future;
use std::pin::Pin;
use std::task::{Context, Poll, Waker};
use std::option::Option;
use std::time::{Duration, Instant};

struct Join<Fut: Future, const N: usize> {
    futures: [Fut; N],
    outputs: [Option<Fut::Output>; N]
}

impl <Fut: Future, const N: usize> Future for Join<Fut, N> {
    type Output = [Fut::Output; N];

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        let this = unsafe { self.get_unchecked_mut() };
        let mut all_done = true;

        // No waker information: we don't know *which* child woke us, so every
        // pending child gets polled on every round. With N children and N
        // rounds that's N*N polls -- the quadratic behaviour from the article.
        for i in 0..this.futures.len() {
            if this.outputs[i].is_some() {
                continue;
            }

            let fut = unsafe { Pin::new_unchecked(&mut this.futures[i]) };
            match fut.poll(cx) {
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

/// A timer that is ready once its deadline has passed. It never calls
/// `cx.waker()`, so the runtime has no choice but to re-poll it periodically.
struct Timer {
    id: usize,
    deadline: Instant,
    polls: usize,
}

impl Future for Timer {
    type Output = usize;

    fn poll(mut self: Pin<&mut Self>, _cx: &mut Context<'_>) -> Poll<usize> {
        self.polls += 1;
        println!("  timer {} polled (poll #{})", self.id, self.polls);

        if Instant::now() >= self.deadline {
            Poll::Ready(self.polls)
        } else {
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
    };
    let mut join = std::pin::pin!(join);

    // Minimal "runtime": sleep a bit, then blindly re-poll the whole tree,
    // because without wakers nobody can tell us which child made progress.
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
    println!("done after {rounds} rounds and {total} child polls (5 timers x {rounds} rounds)");
}
