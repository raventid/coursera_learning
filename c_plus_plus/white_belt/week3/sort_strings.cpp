#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <algorithm>

int main() {
  int n;
  std::vector<std::string> words;
  std::cin >> n;

  for(int i = 0; i < n; i++) {
    std::string str;
    std::cin >> str;

    words.push_back(str);
  }

  std::sort(words.begin(), words.end(), [](const std::string& a, const std::string& b){
      std::string left(a);
      std::string right(b);
      std::transform(a.begin(), a.end(), left.begin(), ::tolower);
      std::transform(b.begin(), b.end(), right.begin(), ::tolower);
      return left < right;
    });

  for(auto& s : words) {
    std::cout << s << " ";
  }

  return 0;
}
