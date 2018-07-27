pub struct Queue<T> {
    older: Vec<T>,
    younger: Vec<T>
}

impl<T> Queue<T> {
    pub fn new() -> Self {
        Queue { older: Vec::new(), younger: Vec::new() }
    }

    pub fn push(&mut self, t: T) {
        self.younger.push(t);
    }

    pub fn is_empty(&self) -> bool {
        self.younger.is_empty() && self.older.is_empty()
    }
}

fn main () {
    // Use `turbofish` when you can't infer type here
    let _q = Queue::<char>::new();
}
