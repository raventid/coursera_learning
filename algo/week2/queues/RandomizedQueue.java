package week2.queues;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class RandomizedQueue<Item> implements Iterable<Item> {
    private Item[] storage;

    // construct an empty randomized queue
    public RandomizedQueue() {
        this.storage = (Item[]) new Object[10];
    }

    // is the randomized queue empty?
    public boolean isEmpty() {
        return true;
    }

    // return the number of items on the randomized queue
    public int size() {
        return 0;
    }

    // add the item
    public void enqueue(Item item) {
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
        var randQeueu = new RandomizedQueue<Integer>();


    }
}
