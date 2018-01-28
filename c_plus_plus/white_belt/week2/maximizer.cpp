#include <iostream>

// Напишите функцию UpdateIfGreater, которая принимает два целочисленных аргумента: first и second.
// Если first оказался больше second, Ваша функция должна записывать в second значение параметра first.
// При этом изменение параметра second должно быть видно на вызывающей стороне.


void UpdateIfGreater(int first, int& second) {
  if (first > second) {
    second = first;
  }
}

// Super obvious solution
// Sounds not very professional, but I won't write any tests)
// int main() {
//   return 0;
// }
