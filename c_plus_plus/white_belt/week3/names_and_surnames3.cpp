#include <iostream>
#include <vector>
#include <string>
#include <map>

class Person {
public:
  Person(const std::string& name, const std::string& lastname, int birth) {
    _name = name;
    _lastname = lastname;
    _birth = birth;
    ChangeFirstName(birth, name);
    ChangeLastName(birth, lastname);
  }
  void ChangeFirstName(int year, const std::string& first_name) {
    // добавить факт изменения имени на first_name в год year
    firstname_datalog[year] = first_name;
  }
  void ChangeLastName(int year, const std::string& last_name) {
    // добавить факт изменения фамилии на last_name в год year
    lastname_datalog[year] = last_name;
  }
  std::string GetFullName(int year) const {
    if(_birth > year) {
      return "No person";
    }

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
  std::string GetFullNameWithHistory(int year) const {
    if(_birth > year) {
      return "No person";
    }

    std::vector<std::string> lastnames;
    std::vector<std::string> firstnames;
    std::string result;

    std::string previous_name;
    for(const auto& name : firstname_datalog) {
      if(year >= name.first) {
        if(previous_name != name.second && name.second.size() > 0) {
          firstnames.push_back(name.second);
          previous_name = name.second;
        }
      }
    }

    std::string previous_lastname;
    for(const auto& lastname : lastname_datalog) {
      if(year >= lastname.first) {
        if(previous_lastname != lastname.second && lastname.second.size() > 0) {
          lastnames.push_back(lastname.second);
          previous_lastname = lastname.second;
        }
      }
    }

    std::string formatted_firstname;
    if(firstnames.size() > 0) {
      formatted_firstname = firstnames[firstnames.size()-1];

      if(firstnames.size() > 1) {
        formatted_firstname += " (";
        for(int i = firstnames.size()-2; i >= 0; i--) {
          formatted_firstname += firstnames[i];
          if(i != 0) {
            formatted_firstname += ", ";
          }
        }
        formatted_firstname += ")";
      }
    }


    std::string formatted_lastname;
    if(lastnames.size() > 0) {
      formatted_lastname = lastnames[lastnames.size()-1];

      if(lastnames.size() > 1) {
        formatted_lastname += " (";
        for(int i = lastnames.size()-2; i >= 0; i--) {
          formatted_lastname += lastnames[i];
          if(i != 0) {
            formatted_lastname += ", ";
          }
        }
        formatted_lastname += ")";
      }
    }

    if(formatted_firstname.size() && formatted_lastname.size()) {
      result = formatted_firstname;
      result += " ";
      result += formatted_lastname;
    } else if(formatted_firstname.size() && !formatted_lastname.size()) {
      result = formatted_firstname;
      result += " with unknown last name";
    } else if(!formatted_firstname.size() && formatted_lastname.size()) {
      result = formatted_lastname;
      result += " with unknown first name";
    } else {
      result = "Incognito";
    }

    return result;
  }
private:
  std::string _name;
  std::string _lastname;
  int _birth;
  std::map<int, std::string> firstname_datalog;
  std::map<int, std::string> lastname_datalog;
  // приватные поля
};

// int main() {
//   Person person("Polina", "Sergeeva", 1960);
//   for (int year : {1959, 1960}) {
//     std::cout << person.GetFullNameWithHistory(year) << std::endl;
//   }

//   person.ChangeFirstName(1965, "Appolinaria");
//   person.ChangeLastName(1967, "Ivanova");
//   for (int year : {1965, 1967}) {
//     std::cout << person.GetFullNameWithHistory(year) << std::endl;
//   }

//   return 0;
// }
