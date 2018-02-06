#include <iostream>
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

// int main () {
//   std::string my_str;

//   std::cout << "Enter your string: ";
//   std::cin >> my_str;

//   if (IsPalindrom(my_str)) {
//     std::cout << "This is Palindrom!" << std::endl;
//   } else {
//     std::cout << "This is not a Palindrom :((" << std::endl;
//   }

//   return 0;
// }
