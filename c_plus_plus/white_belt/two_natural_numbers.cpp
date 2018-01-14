#include <iostream>

// Дано два натуральных числа A и B, не превышающих 1 000 000. Напишите программу, которая вычисляет целую часть частного от деления A на B.
// Если B = 0, выведите "Impossible".

int main() {
  int a,b;

  std::cin >> a >> b;

  if (b != 0) {
    std::cout << (a / b);
  } else {
    std::cout << "Impossible";
  }

  return 0;
}
