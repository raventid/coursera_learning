#include <iostream>
#include <vector>

// Реализуйте функцию void Reverse(vector<int>& v),
// которая переставляет элементы вектора в обратном порядке.

void Reverse(std::vector<int>& v) {
  std::vector<int> reversed;

  for(int i = v.size() - 1; i >= 0; i--) {
    reversed.push_back(v[i]);
  }

  v = reversed;
}

// I'm ninja. No tests needed.
// int main() {
//   return 0;
// }
