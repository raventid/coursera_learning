use std::sync::{Arc, Mutex, Condvar};

pub struct Sender<T> {
    inner: Arc<Inner<T>>
}

pub struct Receiver<T> {
    inner: Arc<Inner<T>>
}

struct Inner<T> {
    queue: Mutex<Vec<T>>
}

pub fn channel<T>() -> (Sender<T>, Receiver<T>) {
    let inner = Mutex::default();

    let inner = Arc::new(inner);

    (Sender {inner: inner.clone()}, Receiver {inner})
}
