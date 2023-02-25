// g++ -ggdb -O0 -o missing_number missing_number.cpp && ./missing_number

#include <iostream>

using namespace std;

int main() {
  int n;

  cin >> n;
  for (int i = 1; i <= n; i++) {
    int m;
    cin >> m;
    if (i != m) {
      cout << i;
      break;
    }
  }
}
