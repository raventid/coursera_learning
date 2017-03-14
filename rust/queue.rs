struct Queue<T> {
  older: Vec<T>,
  younger: Vec<T>
}

impl<T> Queue<T> {
  fn new() -> Self {
    Queue { older: Vec::new() , younger: Vec::new() }
  }

  fn is_empty(&self) -> bool {
    self.older.is_empty() && self.younger.is_empty()
  }

  fn push(&mut self, c: T) {
    self.younger.push(c);
  }
  
  fn pop(&mut self) -> Option<T> {
    if self.older.is_empty() {
      if self.younger.is_empty() {
        return None;
      }
      use std::mem::swap;
      swap(&mut self.older, &mut self.younger);
      self.older.reverse();
    }

    self.older.pop()
  }

  // Here will take ownership for queue 
  fn split(self) -> (Vec<T>, Vec<T>) {
    (self.older, self.younger) 
  }
}

let mut q = Queue::new();
q.push('0');
q.push('1');
assert_eq!(q.pop(), Some('0'));

q.push('w');
assert_eq!(q.pop(), Some('1'));
assert_eq!(q.pop(), Some('w'));
assert_eq!(q.pop(), None);

assert!(q.is_empty());
q.push('*');
assert!(!q.is_empty());
q.pop();

q.push('P');
q.push('X');
assert_eq!(q.pop(), Some('P'));
q.push('Z');

let(older, younger) = q.split();
assert_eq!(older, vec!['X']);
assert_eq!(younger, vec!['Z']);
