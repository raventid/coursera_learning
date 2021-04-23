package week1;

class QuickUnionUF {
    private int[] id;

    public QuickUnionUF(int n) {
        id = new int[n];
        for (int i = 0; i < n; i++) {
            id[i] = i;
        }
    }

    // Here we have a problem. What if our tree goes too tall?
    // In this case we'll do a lot of jumps to find the root and if we
    // have a lot of union request it would take significant time
    // to do.
    private int root(int i) {
        while(i != id[i]) {
            i = id[i];
        }
        return i;
    }

    private boolean connected(int p, int q) {
        return root(p) == root(q);
    }

    public void union(int p, int q) {
        int i = root(p);
        int j = root(q);
        id[i] = j;
    }
}
