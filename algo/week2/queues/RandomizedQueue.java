package week2.queues;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class RandomizedQueue<Item> implements Iterable<Item> {
    private Item[] storage;
    private int nextSlot;
    private int size;

    // construct an empty randomized queue
    public RandomizedQueue() {
        this.storage = (Item[]) new Object[10];
        this.nextSlot = 0;
        this.size = 0;
    }

    // is the randomized queue empty?
    public boolean isEmpty() {
        return size == 0;
    }

    // return the number of items on the randomized queue
    public int size() {
        return size;
    }

    // add the item
    public void enqueue(Item item) {
        this.storage[this.nextSlot] = item;
        this.nextSlot += 1;
        this.size +=1;
    }

    // remove and return a random item
    public Item dequeue() {
        return null;
    }

    // return a random item (but do not remove it)
    public Item sample() {
        return null;
    }

    // return an independent iterator over items in random order
    public Iterator<Item> iterator() {
        return new Iter();
    }

    private class Iter implements Iterator<Item> {
        public boolean hasNext() {
            return false;
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }

        public Item next() {
            return null;
        }
    }

    // unit testing (required)
    public static void main(String[] args) {
        var rq = new RandomizedQueue<Integer>();

        rq.enqueue(10);
        rq.enqueue(20);
        rq.enqueue(30);
    }
}
