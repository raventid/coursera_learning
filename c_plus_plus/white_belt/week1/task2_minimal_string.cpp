#include <iostream>
#include <string>

int main() {
  std::string a, b, c;
  std::cin >> a >> b >> c;
  if(a > b) {
    if(b > c) {
      std::cout << c;
    } else {
      std::cout << b;
    }
  } else {
    if(a > c) {
      std::cout << c;
    } else {
      std::cout << a;
    }
  }

  // if (a >= b) && (a >= c) a;
  // if (b >= a) && (b >= c) b;
  // if (c >= a) && (c >= b) c;
  return 0;
}
