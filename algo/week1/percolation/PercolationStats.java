package week1.percolation;

import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.StdStats;
import edu.princeton.cs.algs4.WeightedQuickUnionUF;

public class PercolationStats {
    private double[] results;

    public PercolationStats(int size, int trials) {
        assertPositive(size);
        assertPositive(trials);

        results = new double[trials];
        runExperiments(size, trials);
    }

    private void assertPositive(int num) {
        if (num < 1) {
            throw new IllegalArgumentException();
        }
    }

    private void runExperiments(int size, int trials) {
        for (int i = 0; i < trials; i++) {
            results[i] = runExperiment(size);
        }
    }

    private double runExperiment(int size) {
        Percolation p = new Percolation(size);
        int openCells = 0;
        do {
            int row = random(size);
            int col = random(size);
            if (!p.isOpen(row, col)){
                p.open(row, col);
                openCells++;
            }
        } while (!p.percolates());

        return (double) openCells/((double) size*size);
    }

    private int random(int size) {
        return StdRandom.uniform(1, size + 1);
    }

    public double mean() {
        return StdStats.mean(results);
    }

    public double stddev() {
        return StdStats.stddev(results);
    }

    public double confidenceLo() {
        return this.mean() - this.confidence();
    }

    private double confidence() {
        return (1.96 * stddev() / Math.sqrt(results.length));
    }

    public double confidenceHi() {
        return this.mean() + this.confidence();
    }

    public static void main(String[] args) {
        PercolationStats stats = new PercolationStats(Integer.parseInt(args[0]), Integer.parseInt(args[1]));
        System.out.println("mean                    = " + stats.mean());
        System.out.println("stddev                  = " + stats.stddev());
        System.out.println("95% confidence interval = " + stats.confidenceLo() + ", " + stats.confidenceHi());
    }
}
