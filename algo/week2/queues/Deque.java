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
        size += 1;
    }

    // remove and return the item from the front
    public Item removeFirst() {
        size -= 1;
        return null;
    }

    // remove and return the item from the back
    public Item removeLast() {
        size -= 1;
        return null;
    }

    public Iterator<Item> iterator() {
        return new ListIterator();
    }

    private class ListIterator implements Iterator<Item> {
        private Node current = leftGuard;

        public boolean hasNext() {
            return current != null;
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }

        public Item next()
        {
            if (current == null) throw new NoSuchElementException();
            Item value = current.item;
            current = current.next;
            return value;
        }
    }

    // return an iterator over items in order from front to back
    // public Iterator<Item> iterator() {}

    // unit testing (required)
    public static void main(String[] args) {
        var deque = new Deque<Integer>();
        deque.addFirst(10);

    }

}
