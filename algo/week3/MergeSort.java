package week3;

class MergeSort {
    private static Comparable[] aux;

    private static void sort(Comparable[] a, int lo, int hi) {
        if (hi <= lo) { return; }
        int mid = lo + (hi - lo)/2;
        sort(a, lo, mid);
        sort(a, mid+1, hi);
        merge(a, lo, mid, hi);
    }

    private static boolean less(Comparable a, Comparable b) {
        return a.compareTo(b) < 0;
    }

    private static void merge(Comparable[] a, int lo, int mid, int hi) {
        int i = lo, j = mid+1;

        for (int k = lo; k <= hi; k++) {
            aux[k] = a[k];
        }

        for (int k = lo; k <= hi; k++) {
            if (i > mid)                   { a[k] = aux[j++]; } // left half exhausted, take from the right
            else if (j > hi)               { a[k] = aux[i++]; } // right half exhausted, take from the left
            else if (less(aux[j], aux[i])) { a[k] = aux[j++]; } // if key on right less than key on the left, take right one (the smaller)
            else                           { a[k] = aux[i++]; } // last case, left key is equal or smaller than right one (let's take it (left one))
        }
    }

    public static void sort(Comparable[] a) {
        aux = new Comparable[a.length];
        sort(a, 0, a.length - 1);
    }

    public static void main(String[] args) {
        var vector =  new String[]{ "dog", "cat", "parrot", "julian", "raventid" };

        for (var e : vector) {
            System.out.println(e);
        }
        System.out.println("");

        sort(vector);

        System.out.println("--------------------");
        System.out.println("After sorting");
        System.out.println("--------------------");

        for (var e : vector) {
            System.out.println(e);
        }
    }
}
