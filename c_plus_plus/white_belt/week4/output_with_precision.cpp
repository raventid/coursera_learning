#include <iostream>
#include <iomanip>
#include <fstream>

int main() {
  std::ifstream input("input.txt");

  // BTW we can set manipulators one time for every output.
  // std::cout << std::fixed << std::setprecision(3)
  // It will work for every output.


  // Not very flexible, but works somehow.
  double value;
  while(input >> value) {
    std::cout << std::fixed << std::setprecision(3) << value << std::endl;
  }

  return 0;
}
