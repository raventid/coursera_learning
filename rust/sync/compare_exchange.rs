use std::sync::atomic::*;
use std::sync::atomic::Ordering::*;
use std::thread;

static mut DATA: String = String::new();
static LOCKED: AtomicBool = AtomicBool::new(false);

fn f(i: u8) {
    // This approach works like mutex in this case
    if LOCKED.compare_exchange(false, true, Acquire, Relaxed).is_ok() {

        // Safety: We hold the exclusive lock, so nothing else is accessing DATA.
        unsafe { DATA.push_str(&format!("{} ", i)) };

        LOCKED.store(false, Release);
    }
}

fn main() {
    thread::scope(|s| {
        for i in 0..100 {
            s.spawn(move || f(i));
        }
    });

    // Not necessary `thread::scope` does join which is the sync point
    thread::sleep(std::time::Duration::from_millis(5_000));

    println!("{}", unsafe { DATA.clone() });
}
