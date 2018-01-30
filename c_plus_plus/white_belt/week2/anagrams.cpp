#include <iostream>
#include <string>
#include <map>

// Слова называются анаграммами друг друга, если одно из них можно получить перестановкой букв в другом.
// Например, слово «eat» можно получить перестановкой букв слова «tea», поэтому эти слова являются анаграммами друг друга.
// Даны пары слов, проверьте для каждой из них, являются ли слова этой пары анаграммами друг друга.

std::map<char, int> BuildCharCounters(const std::string& word) {
  std::map<char, int> dict;

  for(const auto letter : word) {
    dict[letter]++; // we don't need to check if element exists, c++ is smart
  }

  return dict;
}

int main() {
  int n;
  std::cin >> n;

  for(int i = 0; i < n; i++) {
    std::string left, right;

    std::cin >> left;
    std::cin >> right;

    if(BuildCharCounters(left) == BuildCharCounters(right)) {
      std::cout << "YES" << std::endl;
    } else {
      std::cout << "NO" << std::endl;
    }

  }
  return 0;
}
