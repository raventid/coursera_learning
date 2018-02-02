#include <iostream>
#include <set>
#include <string>

int main() {
  int n;
  std::cin >> n;

  std::set<std::string> strings;

  for(int i = 0; i < n; i++) {
    std::string str;
    std::cin >> str;

    strings.insert(str);
  }

  std::cout << strings.size();

  return 0;
}
