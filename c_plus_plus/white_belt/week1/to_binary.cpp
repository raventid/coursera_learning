#include <iostream>
#include <vector>
#include <algorithm>

// На вход дано целое положительное число N.
// Выведите его в двоичной системе счисления без ведущих нулей.

int main () {
  int n, rem;
  bool not_yet = true;
  std::vector<int> v = {};

  std::cin >> n;

  while (n > 1) {
    rem = n % 2;
    n = n / 2;
    v.push_back(rem);
  }

  if (n == 1) { v.push_back(1); }
  std::reverse(v.begin(), v.end());
  for (auto e : v) { std::cout << e; }

  return 0;
}
