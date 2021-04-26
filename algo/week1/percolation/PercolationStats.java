import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.StdStats;
import java.lang.Math;

public class PercolationStats {
    // n-by-n grid
    private int n;

    // # of trials
    private int trials;

    // results of percolations
    private double[] results;

    // the average value in results
    private double mean;

    // sample standard deviation of percolation threshold
    private double stddev;

    // low endpoint of 95% confidence interval
    private double cfdLow;

    // high endpoint of 95% confidence interval
    private double cfdHigh;

    // confidence level at 95%
    private final static double CFD_CRITICAL_VAL = 1.96;

    // perform trials independent experiments on an n-by-n grid
    public PercolationStats(int n, int trials) {
        if (n <= 0 || trials <= 0) {
            throw new java.lang.IllegalArgumentException("arguments n and trials should be greater than 0");
        }

        this.n = n;
        this.trials = trials;
        this.results = new double[trials];

        for(int i = 0; i < trials; i++) {
            Percolation sy = new Percolation(n);
            while(!sy.percolates()) {
                int row = StdRandom.uniform(1, n+1);
                int col = StdRandom.uniform(1, n+1);
                sy.open(row, col);
            }

            double result = (double)sy.numberOfOpenSites() / (n * n);
            this.results[i] = result;
        }

        this.mean = StdStats.mean(results);
        this.stddev = StdStats.stddev(results);
        this.cfdLow = this.mean - PercolationStats.CFD_CRITICAL_VAL * (this.stddev / Math.sqrt(trials));
        this.cfdHigh = this.mean + PercolationStats.CFD_CRITICAL_VAL * (this.stddev / Math.sqrt(trials));
    }

    // sample mean of percolation threshold
    public double mean() {
        return this.mean;
    }

    // sample standard deviation of percolation threshold
    public double stddev() {
        return this.stddev;
    }

    // low endpoint of 95% confidence interval
    public double confidenceLo() {
        return this.cfdLow;
    }

    // high endpoint of 95% confidence interval
    public double confidenceHi() {
        return this.cfdHigh;
    }

    // test client (described below)
    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);
        int T = Integer.parseInt(args[1]);

        System.out.println(String.format("%-20s= %d", "n", n));
        System.out.println(String.format("%-20s= %d", "T", T));

        try {
            PercolationStats statsOne = new PercolationStats(n, T);
            System.out.println(String.format("%-20s= %f" , "mean", statsOne.mean()));
            System.out.println(String.format("%-20s= %f" , "stddev", statsOne.stddev()));
            System.out.println(String.format("%-20s= %f, %f" , "95% confidence interval", statsOne.confidenceLo(), statsOne.confidenceHi()));
        } catch(IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
