#include <iostream>
#include <string>
#include <map>

// Реализуйте справочник столиц стран.

// На вход программе поступают следующие запросы:

// CHANGE_CAPITAL country new_capital — изменение столицы страны country на new_capital,
// либо добавление такой страны с такой столицей, если раньше её не было.
// RENAME old_country_name new_country_name — переименование страны из old_country_name
// в new_country_name.
// ABOUT country — вывод столицы страны country.
// DUMP — вывод столиц всех стран.

int main() {
  int n;
  std::cin >> n;

  std::map<std::string, std::string> capitals;

  // dispatch loop:
  for(int i = 0; i < n; i++) {
    std::string command;
    std::string country;
    std::string capital;
    std::string new_capital;

    std::cin >> command;

    if (command == "CHANGE_CAPITAL") {
      std::cin >> country;
      std::cin >> new_capital;

      // Country didn't exist before
      if(capitals.count(country) == 0) {
        std::cout
          << "Introduce new country "
          << country
          << " with capital "
          << new_capital;
        capitals[country] = new_capital;
      } else if(capitals[country] == new_capital) {
        std::cout << "Country " << country  << " hasn't changed its capital";
      } else if(capitals[country] != new_capital) {
        std::cout
          << "Country "
          << country
          << " has changed its capital from "
          << capitals[country]
          << " to "
          << new_capital;
        capitals[country] = new_capital;
      }

      std::cout << std::endl;
    }

    if (command == "RENAME") {
      std::string old_country_name, new_country_name;

      std::cin >> old_country_name;
      std::cin >> new_country_name;

      if(capitals.count(new_country_name) || !capitals.count(old_country_name)) {
        std::cout << "Incorrect rename, skip";
      } else {
        std::cout
          << "Country "
          << old_country_name
          << " with capital "
          << capitals[old_country_name]
          << " has been renamed to "
          << new_country_name;

        capitals[new_country_name] = capitals[old_country_name];
        capitals.erase(old_country_name);
      }

      std::cout << std::endl;
    }

    if (command == "ABOUT") {
      std::string country;

      std::cin >> country;

      if(capitals.count(country)) {
        std::cout
          << "Country "
          << country
          << " has capital "
          << capitals[country];
      } else {
        std::cout << "Country " << country << " doesn't exist";
      }

      std::cout << std::endl;
    }

    if (command == "DUMP") {
      if (capitals.empty()) {
        std::cout << "There are no countries in the world";
      } else {
        for(const auto& pair : capitals) {
          std::cout << pair.first << "/" << pair.second << " ";
        }
      }
      std::cout << std::endl;
    }
  }
  return 0;
}
