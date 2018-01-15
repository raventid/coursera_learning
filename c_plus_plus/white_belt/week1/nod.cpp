#include <iostream>

// В stdin даны два натуральных числа.
// Найти их наибольший общий делитель.

int main() {
  int a,b;

  std::cin >> a >> b;

  while (a != b) {
		if (a > b) {
			a = a - b;
		} else {
			b = b - a;
		}
	}

  std::cout << a;

  return 0;
}
