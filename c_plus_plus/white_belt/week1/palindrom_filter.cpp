#include <iostream>
#include <vector>
#include <string>

bool IsPalindrom(std::string str) {
  if (0 == str.length()) {
    return true;
  }

  for(int i = 0; i < str.length(); i++) {
    if(str[i] != str[str.length() - i - 1]) {
      return false;
    }
  }

  return true;
}

std::vector<std::string> PalindromFilter(std::vector<std::string> words, int minLength) {
  std::vector<std::string> result;

  for (auto w : words) {
    if (IsPalindrom(w) && (w.length() >= minLength)) {
      result.push_back(w);
    }
  }

  return result;
}

// int main () {
//   std::string my_str;
//   std::vector<std::string> words = {
//     "madam",
//     "hello",
//     "X"
//   };

//   for (auto w : PalindromFilter(words, 10)) {
//     std::cout << w << std::endl;
//   }

//   return 0;
// }
