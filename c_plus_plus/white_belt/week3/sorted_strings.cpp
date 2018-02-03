#include <iostream>
#include <vector>
#include <map>

// It might be cheaper to just use vector and sort it in GetSortedStrings
class SortedStrings {
public:
  void AddString(const std::string& s) {
    words[s]++;
  }

  std::vector<std::string> GetSortedStrings() {
    std::vector<std::string> result;

    for(const auto& w : words) {
      for(int i = 0; i < w.second; i++) {
        result.push_back(w.first);
      }
    }

    return result;
  }
private:
  std::map<std::string, int> words;
};


// void PrintSortedStrings(SortedStrings& strings) {
//   for (const std::string& s : strings.GetSortedStrings()) {
//     std::cout << s << " ";
//   }
//   std::cout << std::endl;
// }

// int main() {
//   SortedStrings strings;

//   strings.AddString("first");
//   strings.AddString("third");
//   strings.AddString("second");
//   PrintSortedStrings(strings);

//   strings.AddString("second");
//   PrintSortedStrings(strings);

//   return 0;
// }
