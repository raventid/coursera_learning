package week1.percolation;

import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.StdStats;
import edu.princeton.cs.algs4.WeightedQuickUnionUF;

public class Percolation {
    private boolean[][] grid;
    private int size;
    private int numberOfOpen;
    private int topVirtualCell;
    private int bottomVritualCell;
    private WeightedQuickUnionUF waterFilling;
    private WeightedQuickUnionUF backwash;

    // creates n-by-n grid, with all sites initially blocked
    public Percolation(int n) {
        if (n <= 0) { throw new IllegalArgumentException(); }

        this.size = n;
        this.waterFilling = new WeightedQuickUnionUF(n*n + 2);
        this.backwash = new WeightedQuickUnionUF(n*n + 2);
        this.numberOfOpen = 0;
        this.topVirtualCell = 0;
        this.bottomVritualCell = n * n + 1;
        this.grid = new boolean[n][];
        for (int i = 0; i < n; i++) {
            grid[i] = new boolean[n];

            for (int j = 0; j < n; j++) {
                grid[i][j] = false;
            }
        }
    }

    // opens the site (row, col) if it is not open already
    public void open(int row, int col) {
        assertRange(row, col);
        if (this.isOpen(row, col)) { return; }

        row = row - 1;
        col = col - 1;

        // setting it to be open
        grid[row][col] = true;

        // connecting to around components
        this.connect(row, col);
        this.numberOfOpen = this.numberOfOpen + 1;
    }

    // is the site (row, col) open?
    public boolean isOpen(int row, int col) {
        assertRange(row, col);

        row = row - 1;
        col = col - 1;

        return grid[row][col];
    }

    // is the site (row, col) full?
    public boolean isFull(int row, int col) {
        assertRange(row, col);

        return this._isFull(row-1, col-1);
    }

    // returns the number of open sites
    public int numberOfOpenSites() {
        return this.numberOfOpen;
    }

    // does the system percolate?
    public boolean percolates() {
        int topRoot = this.backwash.find(this.topVirtualCell);
        int bottomRoot = this.backwash.find(this.bottomVritualCell);
        return topRoot == bottomRoot;
    }

    private void assertRange(int row, int col) {
        if (row <= 0 || row > this.size || col <= 0 || col > this.size) {
            throw new IllegalArgumentException();
        }
    }

    private void connect(int row, int col) {
        int index = this.getIndex(row, col);

        // Top line should always be connected to flow source
        // Plus it should be connected to every bottom line
        if (this.shouldConnectToTop(row)) {
            this.waterFilling.union(index, this.topVirtualCell);
            this.backwash.union(index, this.topVirtualCell);
        }

        // This is a percolation detector we connect all
        // the bottom nodes to backwash UF.
        if (this.shouldConnectToBottom(row)) {
            this.backwash.union(index, this.bottomVritualCell);
        }

        int above = this.getAboveCell(row, col);
        if (above != -1) {
            this.waterFilling.union(index, above);
            this.backwash.union(index, above);
        }

        int left = this.getLeftCell(row, col);
        if (left != -1) {
            this.waterFilling.union(index, left);
            this.backwash.union(index, left);
        }

        int right = this.getRightCell(row, col);
        if (right != -1) {
            this.waterFilling.union(index, right);
            this.backwash.union(index, right);

        }

        int bottom = this.getBottomCell(row, col);
        if (bottom != -1) {
            this.waterFilling.union(index, bottom);
            this.backwash.union(index, bottom);
        }
    }

    private boolean _isFull(int row, int col) {
        int topRoot = waterFilling.find(this.topVirtualCell);
        int current = waterFilling.find(this.getIndex(row, col));
        return topRoot == current;
    }

    // If size of the grid is 3x3:
    // - 0,0 is 0 + 0 + 1 = 1
    // - 1,2 is 3 + 2 + 1 = 6
    // 0 is the left boundary, we don't use it in grid
    // size+1 is the right boundary, we don't use it in grid
    private int getIndex(int row, int col) {
        return (row * this.size) + col + 1;
    }

    private boolean shouldConnectToTop(int row) {
        return row == 0;
    }

    private boolean shouldConnectToBottom(int row) {
        return lastRow(row);
    }

    private boolean lastRow(int row) {
        return row == this.size - 1;
    }

    private int getAboveCell(int row, int col) {
        int previousRow = row - 1;

        if (row == 0) { return -1; }
        if (!this.isOpen(previousRow+1, col+1)) { return -1; }

        return this.getIndex(previousRow, col);
    }

    private int getLeftCell(int row, int col) {
        int previousCol = col - 1;

        if (col == 0) { return -1; }
        if (!this.isOpen(row+1, previousCol+1)) { return -1; }

        return this.getIndex(row, previousCol);
    }

    private int getRightCell(int row, int col) {
        int nextCol = col + 1;

        if (col == this.size - 1) { return -1; }
        if (!this.isOpen(row+1, nextCol+1)) { return -1; }

        return this.getIndex(row, nextCol);
    }

    private int getBottomCell(int row, int col) {
        int nextRow = row + 1;

        if (this.lastRow(row)) { return -1; }
        if (!this.isOpen(nextRow+1, col+1)) { return -1; }

        return this.getIndex(nextRow, col);
    }
}
