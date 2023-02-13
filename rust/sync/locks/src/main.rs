use std::{sync::atomic::{self, AtomicU32}, cell::UnsafeCell};

pub struct Mutex<T> {
    // 0: unlocked
    // 1: locked
    state: AtomicU32,
    value: UnsafeCell<T>
}

fn main() {
    println!("Hello, world!");
}
