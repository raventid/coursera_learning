package week2.queues;

import java.util.Iterator;
import java.util.NoSuchElementException;
import edu.princeton.cs.algs4.StdRandom;

public class RandomizedQueue<Item> implements Iterable<Item> {
    private Item[] storage;
    private int size;

    // construct an empty randomized queue
    public RandomizedQueue() {
        this.storage = (Item[]) new Object[1];
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
        if (item == null) { throw new IllegalArgumentException(); }
        if (size == storage.length) {
            resize(storage.length * 2);
        }

        storage[size] = item;
        size += 1;
    }

    // remove and return a random item
    public Item dequeue() {
        if (size == 0) { throw new NoSuchElementException(); }
        int index = StdRandom.uniform(size);
        Item elem = storage[index];

        // fill gap with last element and decrease size
        storage[index] = storage[size];
        storage[size] = null;
        size -= 1;

        if (size > 0 && size == storage.length/4) {
            resize(storage.length/2);
        }

        return elem;
    }

    // return a random item (but do not remove it)
    public Item sample() {
        if (size == 0) { throw new NoSuchElementException(); }
        int index = StdRandom.uniform(size);
        return storage[index];
    }

    // return an independent iterator over items in random order
    public Iterator<Item> iterator() {
        return new Iter();
    }

    private class Iter implements Iterator<Item> {
        private Item[] iteratee;
        private int cursor = 0;

        Iter() {
            // The same logic as in deque and resize combined together
            int length = storage.length;
            int size = length;
            Item[] copy = (Item[]) new Object[length];
            Item[] iteratee = (Item[]) new Object[length];

            for (int i = 0; i < length; i++) {
                copy[i] = storage[i];
            }

            for (int i = 0; i < length; i++) {
                int index = StdRandom.uniform(size);
                Item elem = copy[index];

                copy[index] = copy[size];
                storage[size] = null;
                size -= 1;

                iteratee[i] = elem;
            }
        }

        public boolean hasNext() {
            return cursor < size;
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }

        public Item next() {
            if (size <= cursor) { throw new NoSuchElementException(); }
            Item elem = iteratee[cursor];
            cursor += 1;

            return elem;
        }
    }

    private void resize(int capacity) {
        Item[] copy = (Item[]) new Object[capacity];
        for (int i = 0; i < size; i++) {
            copy[i] = storage[i];
        }

        storage = copy;
    }

    // unit testing (required)
    public static void main(String[] args) {
        var rq = new RandomizedQueue<Integer>();

        rq.enqueue(10);
        rq.enqueue(20);
        rq.enqueue(30);

        System.out.println(rq.sample());
        System.out.println(rq.sample());
        System.out.println(rq.sample());

        System.out.println(rq.dequeue());
    }
}
