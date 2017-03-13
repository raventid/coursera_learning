struct Queue {
  older: Vec<char>,
  younger: Vec<char>
}

impl Queue {
  fn new() -> Queue {
    Queue { older: Vec::new() , younger: Vec::new() }
  }

  fn is_empty(self: &Queue) -> bool {
    self.older.is_empty() && self.younger.is_empty()
  }

  fn push(self: &mut Queue, c: char) {
    self.younger.push(c);
  }
  
  fn pop(self: &mut Queue) -> Option<char> {
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
  fn split(self: Queue) -> (Vec<char>, Vec<char>) {
    (self.older, self.younger) 
  }
}

let mut q = Queue { older: Vec::new(), younger: Vec::new() };
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
