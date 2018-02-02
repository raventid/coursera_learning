#include <iostream>
#include <string>
#include <map>
#include <set>

int main() {
  int q;
  std::cin >> q;

  std::map<std::string, std::set<std::string>> synonyms;

  for (int i = 0; i < q; ++i) {
    std::string command;
    std::cin >> command;

    if (command == "ADD") {
      std::string first_word, second_word;
      std::cin >> first_word >> second_word;

      // Support two different sets for different words. Weird, but Yandex
      // asked me to do it this way.
      synonyms[first_word].insert(second_word);

      synonyms[second_word].insert(first_word);

    } else if (command == "COUNT") {
      std::string word;
      std::cin >> word;
      std::cout << synonyms[word].size() << std::endl;

    } else if (command == "CHECK") {
      std::string first_word, second_word;
      std::cin >> first_word >> second_word;

      if (synonyms[first_word].count(second_word) == 1) {
        std::cout << "YES" << std::endl;
      } else {
        std::cout << "NO" << std::endl;
      }
    }
  }
  return 0;
}
