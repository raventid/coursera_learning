package week2.queues;

import edu.princeton.cs.algs4.StdIn;

public class Permutation {
   public static void main(String[] args) {
       var rq = new RandomizedQueue<String>();

       while (!StdIn.isEmpty()) {
           String input = StdIn.readString();
           rq.enqueue(input);
       }

       for (String input : rq) {
           System.out.println(input);
       }
   }
}
