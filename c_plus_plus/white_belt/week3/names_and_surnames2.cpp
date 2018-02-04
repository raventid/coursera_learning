#include <iostream>
#include <vector>
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
  std::string GetFullNameWithHistory(int year) {
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
  std::map<int, std::string> firstname_datalog;
  std::map<int, std::string> lastname_datalog;
  // приватные поля
};

// int main() {
//   Person person;
  
//   person.ChangeFirstName(1965, "Polina");
//   person.ChangeLastName(1967, "Sergeeva");
//   for (int year : {1900, 1965, 1990}) {
//     std::cout << person.GetFullNameWithHistory(year) << std::endl;
//   }
  
//   person.ChangeFirstName(1970, "Appolinaria");
//   for (int year : {1969, 1970}) {
//     std::cout << person.GetFullNameWithHistory(year) << std::endl;
//   }
  
//   person.ChangeLastName(1968, "Volkova");
//   for (int year : {1969, 1970}) {
//     std::cout << person.GetFullNameWithHistory(year) << std::endl;
//   }
  
//   person.ChangeFirstName(1990, "Polina");
//   person.ChangeLastName(1990, "Volkova-Sergeeva");
//   std::cout << person.GetFullNameWithHistory(1990) << std::endl;
  
//   person.ChangeFirstName(1966, "Pauline");
//   std::cout << person.GetFullNameWithHistory(1966) << std::endl;
  
//   person.ChangeLastName(1960, "Sergeeva");
//   for (int year : {1960, 1967}) {
//     std::cout << person.GetFullNameWithHistory(year) << std::endl;
//   }
  
//   person.ChangeLastName(1961, "Ivanova");
//   std::cout << person.GetFullNameWithHistory(1967) << std::endl;
  
//   return 0;
// }
