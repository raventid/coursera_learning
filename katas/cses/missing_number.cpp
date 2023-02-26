// g++ -ggdb -O0 -o missing_number missing_number.cpp && ./missing_number

#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
  int n;
  std::vector<int> input;

  cin >> n;

  // read input to vec (n-1 because 1 number is missing)
  for (int i = 0; i < n-1; i++) {
    int m;
    cin >> m;
    input.push_back(m);
  }

  // sort vec O(n*logn)
  sort(input.begin(), input.end());

  // output the element
  for (int i = 1; i <= n; i++) {
    if (i != input[i-1]) {
      cout << i;
      break;
    }
  }
}
