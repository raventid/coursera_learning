#include <iostream>
#include <string>
#include <map>

class Person {
public:
  void ChangeFirstName(int year, const std::string& first_name) {
    // добавить факт изменения имени на first_name в год year
    firstname_datalog[year] = first_name;
  }
  void ChangeLastName(int year, const std::string& last_name) {
    // добавить факт изменения фамилии на last_name в год year
    lastname_datalog[year] = last_name;
  }
  std::string GetFullName(int year) {
    std::string result;
    std::string firstname;
    std::string lastname;
    // получить имя и фамилию по состоянию на конец года year
    for(const auto& name : firstname_datalog) {
      if(name.first <= year) {
        if(name.second.size()) {
          firstname = name.second;
        } else {
          break;
        }
      }
    }

    for(const auto& surname : lastname_datalog) {
      if(surname.first <= year) {
        if(surname.second.size()) {
          lastname = surname.second;
        } else {
          break;
        }
      }
    }


    if(firstname.size() && lastname.size()) {
      result = firstname;
      result += " ";
      result += lastname;
    } else if(firstname.size() && !lastname.size()) {
      result = firstname;
      result += " with unknown last name";
    } else if(!firstname.size() && lastname.size()) {
      result = lastname;
      result += " with unknown first name";
    } else {
      result = "Incognito";
    }

    return result;
  }
private:
  std::map<int, std::string> firstname_datalog;
  std::map<int, std::string> lastname_datalog;
  // приватные поля
};

// int main() {
//   Person person;

//   person.ChangeFirstName(1965, "Polina");
//   person.ChangeLastName(1967, "Sergeeva");
//   for (int year : {1900, 1965, 1990}) {
//     std::cout << person.GetFullName(year) << std::endl;
//   }

//   person.ChangeFirstName(1970, "Appolinaria");
//   for (int year : {1969, 1970}) {
//     std::cout << person.GetFullName(year) << std::endl;
//   }

//   person.ChangeLastName(1968, "Volkova");
//   for (int year : {1969, 1970}) {
//     std::cout << person.GetFullName(year) << std::endl;
//   }

//   return 0;
// }
