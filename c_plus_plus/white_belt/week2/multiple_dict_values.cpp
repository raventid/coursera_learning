#include <iostream>
#include <map>
#include <set>
#include <string>

std::set<std::string> BuildMapValuesSet(const std::map<int, std::string>& m) {
  std::set<std::string> result;

  for(const auto& kv : m) {
    result.insert(kv.second);
  }

  return result;
}


int main() {
  std::set<std::string> values = BuildMapValuesSet({
      {1, "odd"},
        {2, "even"},
          {3, "odd"},
            {4, "even"},
              {5, "odd"}
    });

  for (const std::string& value : values) {
    std::cout << value << std::endl;
  }

  // Expected output is
  // even
  // odd

  return 0;
}
