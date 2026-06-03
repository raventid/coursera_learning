// Codeforces 158B - Taxi
// https://codeforces.com/problemset/problem/158/B
//
// Groups of size 1..4 must each ride together; a taxi holds 4. Minimise taxis.
// Strategy: two-pointer for the top (4s ride alone, 3s grab a 1), then count
// the remaining 1s and 2s and finish with arithmetic.

#include <iostream>
#include <vector>
#include <algorithm>          // sort, max
using namespace std;

int solve(vector<int>& s) {
    int l = 0, r = (int)s.size() - 1;
    int taxis = 0, ones = 0, twos = 0;

    // Top end: handle 4s and 3s from the largest down.
    while (s[r] == 3 || s[r] == 4) {
        if (l > r) { return taxis; }
        if (l == r) { return taxis + 1; }

        if (s[r] == 4) { taxis++; r--; continue; }
        if (s[r] == 3) { if (s[l] == 1) { l++; } taxis++; r--; continue; }
    }

    // Bottom end: everything left is 1s and 2s. Count them (bounded cursors!).
    while (l <= r && s[l] == 1) { ones++; l++; }
    while (l <= r && s[r] == 2) { twos++; r--; }

    taxis += twos / 2;
    if (twos % 2 == 1) {            // a lone leftover 2 takes its own taxi...
        ones = max(0, ones - 2);    // ...and carries up to two 1s with it
        taxis++;
    }

    taxis += ones / 4;              // remaining 1s, four to a taxi
    if (ones % 4 != 0) { taxis++; } // + one more for the remainder = ceil(ones/4)

    return taxis;
}

int main() {
    ios_base::sync_with_stdio(false);   // fast I/O
    cin.tie(nullptr);

    int n;
    cin >> n;
    vector<int> s(n);
    for (int i = 0; i < n; i++) cin >> s[i];
    sort(s.begin(), s.end());           // ascending — basis of the two pointers

    cout << solve(s) << "\n";
    return 0;
}
