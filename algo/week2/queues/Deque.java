package week2.queues;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class Deque<Item> implements Iterable<Item> {

    private Node leftGuard, rightGuard;
    private int size = 0;

    private class Node {
        Item item;
        Node next;
        Node prev;
    }

    // construct an empty deque
    public Deque() {
        leftGuard = new Node();
        rightGuard = new Node();

        // we are using guards as a markers, they have null in item.
        leftGuard.next = rightGuard;
        rightGuard.prev = leftGuard;
    }

    // is the deque empty?
    public boolean isEmpty() {
        return leftGuard.next == rightGuard;
    }

    // return the number of items on the deque
    public int size() {
        return size;
    }

    // add the item to the front
    public void addFirst(Item item) {
        if (item == null) {
            throw new IllegalArgumentException();
        }

        Node previousLeader = leftGuard.next;
        Node newLeader = new Node();
        newLeader.prev = leftGuard;
        newLeader.next = previousLeader;
        newLeader.item = item;

        previousLeader.prev = newLeader;
        leftGuard.next = newLeader;
        size += 1;
    }

    // add the item to the back
    public void addLast(Item item) {
        if (item == null) {
            throw new IllegalArgumentException();
        }

        Node previousLast = rightGuard.prev;
        Node newLast = new Node();
        newLast.prev = previousLast;
        newLast.next = rightGuard;
        newLast.item = item;

        previousLast.next = newLast;
        rightGuard.prev = newLast;

        size += 1;
    }

    // remove and return the item from the front
    public Item removeFirst() {
        if (this.isEmpty()) { throw new NoSuchElementException(); }

        Node previousLeader = leftGuard.next;
        Node newLeader = leftGuard.next.next;

        leftGuard.next = newLeader;
        newLeader.prev = leftGuard;

        size -= 1;
        return previousLeader.item;
    }

    // remove and return the item from the back
    public Item removeLast() {
        if (this.isEmpty()) { throw new NoSuchElementException(); }

        Node previousLast = rightGuard.prev;
        Node newLast = rightGuard.prev.prev;

        newLast.next = rightGuard;
        rightGuard.prev = newLast;

        size -= 1;
        return previousLast.item;
    }

    public Iterator<Item> iterator() {
        return new ListIterator();
    }

    private class ListIterator implements Iterator<Item> {
        private Node current = leftGuard.next;

        public boolean hasNext() {
            return current != rightGuard;
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }

        public Item next() {
            if (current == rightGuard) { throw new NoSuchElementException(); }
            Item value = current.item;
            current = current.next;
            return value;
        }
    }

    // unit testing (required)
    public static void main(String[] args) {
        var deque = new Deque<Integer>();
        deque.addFirst(10);
        var first = deque.removeFirst();
        System.out.println(first);

        deque.addLast(20);
        var last = deque.removeFirst();
        System.out.println(last);

        deque.addLast(30);
        var last1 = deque.removeLast();
        System.out.println(last1);

        deque.addFirst(10);
        deque.addLast(20);
        deque.addFirst(30);

        for (int i : deque) {
            System.out.println(i);
        }
    }
}
