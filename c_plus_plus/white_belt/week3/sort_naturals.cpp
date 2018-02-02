#include <iostream>
#include <vector>
#include <algorithm>

int main() {
  int n;
  std::cin >> n;
  std::vector<int> numbers;

  for(int i = 0; i < n; i++) {
    int val;
    std::cin >> val;
    numbers.push_back(val);
  }

  std::sort (numbers.begin(), numbers.end(), [](int val, int val2) { return (std::abs(val) < std::abs(val2)); });

  for(auto num : numbers) {
    std::cout << num << " ";
  }

  return 0;
}
