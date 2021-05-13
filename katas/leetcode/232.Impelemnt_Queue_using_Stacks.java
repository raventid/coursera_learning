class MyQueue {
    private Stack<Integer> inbox;
    private Stack<Integer> outbox;

    /** Initialize your data structure here. */
    public MyQueue() {
        this.inbox = new Stack<>();
        this.outbox = new Stack<>();
    }

    /** Push element x to the back of queue. */
    public void push(int x) {
        this.inbox.push(x);
    }

    /** Removes the element from in front of queue and returns that element. */
    public int pop() {
        if (this.outbox.isEmpty()) {
            while (!this.inbox.isEmpty()) {
                this.outbox.push(this.inbox.pop());
            }
        }

        return this.outbox.pop();
    }

    /** Get the front element. */
    public int peek() {
        if (this.outbox.isEmpty()) {
           while (!this.inbox.isEmpty()) {
                this.outbox.push(this.inbox.pop());
            }
        }

        return this.outbox.peek();
    }

    /** Returns whether the queue is empty. */
    public boolean empty() {
        return this.outbox.isEmpty() && this.inbox.isEmpty();
    }
}

/**
 * Your MyQueue object will be instantiated and called as such:
 * MyQueue obj = new MyQueue();
 * obj.push(x);
 * int param_2 = obj.pop();
 * int param_3 = obj.peek();
 * boolean param_4 = obj.empty();
 */
