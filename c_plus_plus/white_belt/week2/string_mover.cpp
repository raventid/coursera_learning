#include <iostream>
#include <vector>
#include <string>

// Напишите функцию MoveStrings, которая принимает два вектора строк,
// source и destination, и дописывает все строки из первого вектора в конец второго.
// После выполнения функции вектор source должен оказаться пустым.

void MoveStrings(std::vector<std::string>& source, std::vector<std::string>& destination) {
  for(auto s : source) {
    destination.push_back(s);
  }
  source.clear();
}

// Let's try without tests one more time, lol.
// int main() {
//   return 0;
// }
