package week2.queues;

import java.util.Iterator;
import java.util.NoSuchElementException;
import edu.princeton.cs.algs4.StdRandom;

public class RandomizedQueue<Item> implements Iterable<Item> {
    private Item[] storage;
    private int size;
    private int capacity;

    // construct an empty randomized queue
    public RandomizedQueue() {
        this.storage = (Item[]) new Object[10];
        this.size = 0;
        this.capacity = 10;
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
        this.storage[this.size] = item;
        this.size += 1;
    }

    // remove and return a random item
    public Item dequeue() {
        return null;
    }

    // return a random item (but do not remove it)
    public Item sample() {
        int index = StdRandom.uniform(this.size);
        return this.storage[index];
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

        System.out.println(rq.sample());
        System.out.println(rq.sample());
        System.out.println(rq.sample());
    }
}
