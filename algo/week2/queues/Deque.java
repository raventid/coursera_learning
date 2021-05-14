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
        leftGuard.next == rightGuard
    }

    // return the number of items on the deque
    public int size() {
        return size;
    }

    // add the item to the front
    public void addFirst(Item item) {
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

    // return an iterator over items in order from front to back
    // public Iterator<Item> iterator() {}

    // unit testing (required)
    public static void main(String[] args)

}
