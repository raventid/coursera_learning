#include <iostream>
#include <fstream>
#include <string>
#include <vector>

struct Student {
  std::string full_name;

  Student(std::string name, std::string lastname, int day, int month, int year) {
    full_name = name;
    full_name += " ";
    full_name += lastname;

    _day = day;
    _month = month;
    _year = year;
  }

  void print_birthdate() {
    std::cout << _day << "." << _month << "." << _year << std::endl;
  }

private:
  int _day, _month, _year;
};

int main() {
  int n;
  std::cin >> n;


  // Getting the data:
  std::vector<Student> students;
  students.push_back({"Example", "Student", 0, 0, 0});

  for(int i = 0; i < n; i++) {
    std::string name, lastname;
    int day, month, year;
    std::cin >> name >> lastname >> day >> month >> year;
    students.push_back({name, lastname, day, month, year});
  }

  // Command handler:

  int m;
  std::cin >> m;

  for(int i = 0; i < m; i++) {
    std::string command;
    std::cin >> command;
    int id;
    std::cin >> id;

    if(command == "name" && id > 0 && id <= n) {
      std::cout << students[id].full_name << std::endl;
    } else if(command == "date" && id > 0 && id <= n) {
      students[id].print_birthdate();
    } else {
      std::cout << "bad request" << std::endl;
    }
  }
  return 0;
}

// Test data:
// DDjsDgddoIllmZG XxraBGsf 865189954 838336585 275438671
// pZnITAEKkZR izuMdrc 514786216 950133076 166474413
// OfjAUQy efzfGLVPnYB 633451460 721262743 793669995
// GnbCcRbygrM TdIIGBEw 226365746 114953262 233877961
// JSrUGJCR YrujmkZSGFttk 396169092 570939788 872405040
// AfrUOJk ciwsN 40757237 518708565 414337061
// ZniLeGFfhdU jDHjFGDexSQZr 214435583 370542888 632426765
// hfNljfKJaMIUCp qIOyXedWTCcytPG 273093282 926285716 103400987
// apRraUzQZc knymORtll 576683321 821511415 483532696
// WEiJUpfxlup tZSrV 913358756 653630923 900912293
