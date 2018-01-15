#include <iostream>
#include <string>

// Дана строка.
// Найдите в этой строке второе вхождение буквы f и выведите индекс этого вхождения.
// Если буква f в данной строке встречается только один раз, выведите число -1,
// а если не встречается ни разу, выведите число -2. Индексы нумеруются с нуля.

int main() {
  std::string s;
  char target = 'f';
  int counter, position = 0;
  int position_of_second = -2;

  std::cin >> s;

  for (auto symbol : s) {
    if (symbol == target) {
      counter++;

      if (counter == 2) {
        position_of_second = position;
      }
    }

    position++; // change the cursor
  }

  if (position_of_second > 0) {
    std::cout << position_of_second;
  } else if (1 == counter) {
    std::cout << -1;
  } else {
    std::cout << -2;
  }

  return 0;
}
