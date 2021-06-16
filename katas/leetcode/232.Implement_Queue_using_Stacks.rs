struct MyQueue {
    pub input_buffer: Vec<i32>,
    pub output_buffer: Vec<i32>
}


/**
 * `&self` means the method takes an immutable reference.
 * If you need a mutable reference, change it to `&mut self` instead.
 */
impl MyQueue {

    /** Initialize your data structure here. */
    fn new() -> Self {
        MyQueue {
            input_buffer: Vec::new(),
            output_buffer: Vec::new()
        }
    }

    /** Push element x to the back of queue. */
    fn push(&mut self, x: i32) {
        self.input_buffer.push(x);
    }

    /** Removes the element from in front of queue and returns that element. */
    fn pop(&mut self) -> i32 {
        if (self.output_buffer.is_empty()) {
            self.output_buffer = self.input_buffer.iter().rev().map(|elem| { *elem }).collect();
            self.input_buffer = Vec::new();
        }

        match self.output_buffer.pop() {
            Some(elem) => elem,
            None => panic!("Don't expect to pop empty")
        }
    }

    /** Get the front element. */
    fn peek(&mut self) -> i32 {
        if (self.output_buffer.is_empty()) {
            self.output_buffer = self.input_buffer.iter().rev().map(|elem| { *elem }).collect();
            self.input_buffer = Vec::new();
        }

        match self.output_buffer.last() {
            Some(elem) => *elem,
            None => panic!("Don't expect to pop empty")
        }
    }

    /** Returns whether the queue is empty. */
    fn empty(&self) -> bool {
      self.input_buffer.is_empty() && self.output_buffer.is_empty()
    }
}

/**
 * Your MyQueue object will be instantiated and called as such:
 * let obj = MyQueue::new();
 * obj.push(x);
 * let ret_2: i32 = obj.pop();
 * let ret_3: i32 = obj.peek();
 * let ret_4: bool = obj.empty();
 */
