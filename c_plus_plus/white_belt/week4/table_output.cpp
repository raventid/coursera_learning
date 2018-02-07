#include <iostream>
#include <fstream>
#include <iomanip>
#include <sstream>

int main() {
  std::ifstream input("input.txt");
  std::string value;
  int height, width;

  input >> height;
  input >> width;

  // std::cout << std::setfill('.');


  auto first = true;

  for(int i = -1; i < height; i++) {
    getline(input, value);

    std::stringstream iss;
    iss << value;

    std::string number;

    for(int j = 0; j < width; j++) {
      if(getline(iss, number, ',')) {
        std::cout << std::setw(10);
        // int num = std::stoi(number);
        std::cout << number;

        if(j != width-1) {
          std::cout << ' ';
        }
      }
    }

    iss.clear();

    if(!first) {
      std::cout << std::endl;
    }

    first = false;

    if(i == height-2) {
      first = true;
    }
  }

  return 0;
}

// // cleaner solution
// int main() {
//   ifstream input("input.txt");

//   int n, m;
//   input >> n >> m;

//   for (int i = 0; i < n; ++i) {
//     for (int j = 0; j < m; ++j) {
//       int x;
//       input >> x;
//       input.ignore(1);
//       std::cout << std::setw(10) << x;
//       if (j != m - 1) {
//         std::cout << " ";
//       }
//     }
//     if (i != n - 1) {
//       std::cout << std::endl;
//     }
//   }

//   return 0;
// }
