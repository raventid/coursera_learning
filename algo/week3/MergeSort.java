package week3;

class MergeSort {
    private static void merge(Comparable[] a, int lo, int mid, int hi) {
        int i = lo, j = mid+1;

        for (int k = lo; k <= hi; k++) {
            aux[k] = a[k]
        }

        for (int k = lo; k <= hi; k++) {
            if (i > mid)                   { a[k] = aux[j++]; }
            else if (j > hi)               { a[k] = aux[i++]; }
            else if (less(aux[j], aux[i])) { a[k] = aux[j++]; }
            else                           { a[k] = aux[i++]; }
        }
    }

    public static void main(String[] args) {
        System.out.println("Hello world");
    }
}
