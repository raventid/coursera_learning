#include <iostream>
#include <cmath>

// ax^2 + bx + c = 0
int main() {
  int a, b, c;
  std::cin >> a >> b >> c;

  if(a==0 && b==0) {
    return 0;
  }

  if(a == 0) {
    std::cout << (-c / (b * 1.0));
    return 0;
  }

  int d = b * b - 4 * a * c;
  auto x1 = (-b + sqrt(d)) / (2 * a);
  auto x2 = (-b - sqrt(d)) / (2 * a);

  if (x1 == x2 && !std::isnan(x1)) {
    std::cout << x1;
  } else {
    if(!std::isnan(x1)) { std::cout << x1; }
    if(!std::isnan(x2)) { std::cout << " " << x2; }
  }
  return 0;
}
