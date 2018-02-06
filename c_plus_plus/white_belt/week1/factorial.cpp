#include <iostream>

int Factorial(int n) {
  int result = 1;
  for(int i=1; i <= n; i++) {
    result = result * i;
  }
  return result;
}

// Main commented because yandex test do not need it, only Factorial function.
// int main() {
//   int number;

//   std::cout << "Enter the number:";
//   std::cin >> number;

//   std::cout << Factorial(number);
//   return 0;
// }
