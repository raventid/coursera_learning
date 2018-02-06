#include <iostream>
#include <fstream>
#include <string>

int main() {
  std::string line;
  std::ifstream input("input.txt");

  std::ofstream output("output.txt");

  while(getline(input, line)) {
    output << line << std::endl;
  }

  return 0;
}
