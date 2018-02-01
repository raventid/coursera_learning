#include <iostream>
#include <map>
#include <vector>
#include <string>
#include <algorithm>


// Реализуйте систему хранения автобусных маршрутов.
// Вам нужно обрабатывать следующие запросы:

// NEW_BUS bus stop_count stop1 stop2 ... — добавить маршрут автобуса с названием bus и stop_count остановками с названиями stop1, stop2, ...
//   BUSES_FOR_STOP stop — вывести названия всех маршрутов автобуса, проходящих через остановку stop.
//   STOPS_FOR_BUS bus — вывести названия всех остановок маршрута bus со списком автобусов, на которые можно пересесть на каждой из остановок.
//   ALL_BUSES — вывести список всех маршрутов с остановками.

// ================================================================================================================================ //

// Формат ввода

// В первой строке ввода содержится количество запросов Q, затем в Q строках следуют описания запросов.

// Гарантируется, что все названия маршрутов и остановок состоят лишь из латинских букв, цифр и знаков подчёркивания.

// Для каждого запроса NEW_BUS bus stop_count stop1 stop2 ... гарантируется, что маршрут bus отсутствует,
// количество остановок больше 0, а после числа stop_count следует именно такое количество названий остановок, причём все названия в каждом списке различны.

// ================================================================================================================================ //

// Для каждого запроса, кроме NEW_BUS, выведите соответствующий ответ на него:

// 1) На запрос BUSES_FOR_STOP stop выведите через пробел список автобусов, проезжающих через эту остановку,
// в том порядке, в котором они создавались командами NEW_BUS.
//  Если остановка stop не существует, выведите No stop.
// 2) На запрос STOPS_FOR_BUS bus выведите описания остановок маршрута bus в отдельных строках в том порядке, в котором они были заданы в соответствующей команде NEW_BUS.
//  Описание каждой остановки stop должно иметь вид Stop stop: bus1 bus2 ..., где bus1 bus2 ... — список автобусов, проезжающих через остановку stop, в порядке, в котором они создавались командами NEW_BUS, за исключением исходного маршрута bus. Если через остановку stop не проезжает ни один автобус, кроме bus, вместо списка автобусов для неё выведите no interchange. Если маршрут bus не существует, выведите No bus.
// 3) На запрос ALL_BUSES выведите описания всех автобусов в алфавитном порядке. Описание каждого маршрута bus должно иметь вид Bus bus: stop1 stop2 ..., где stop1 stop2 ... — список остановок автобуса bus в порядке, в котором они были заданы в соответствующей команде NEW_BUS. Если автобусы отсутствуют, выведите No buses.

void new_bus_handler(std::map< std::string, std::vector< std::string > >& schedule, std::vector<std::string>& ordered_buses) {
  std::string bus;
  int stop_count;
  std::vector<std::string> stops;

  std::cin >> bus;
  std::cin >> stop_count;

  ordered_buses.push_back(bus);

  for(int i = 0; i < stop_count; i++) {
    std::string stop_name;
    std::cin >> stop_name;
    stops.push_back(stop_name);
  }

  schedule[bus] = stops;
}

void buses_for_stop_handler(const std::map< std::string, std::vector< std::string > >& schedule, std::vector<std::string>& ordered_buses) {
  std::string stop;
  std::cin >> stop;

  bool does_stop_exists = false;

  for(const auto& bus : ordered_buses) {
    auto stops = schedule.at(bus);
    if (std::find(stops.begin(), stops.end(), stop) != stops.end()) {
      does_stop_exists = true;
      std::cout << bus << " ";
    }
  }

  if(!does_stop_exists) {
    std::cout << "No stop";
  }

  std::cout << std::endl;
}

void stop_for_bus_handler(const std::map< std::string, std::vector< std::string > >& schedule, std::vector<std::string>& ordered_buses) {
  std::string input_bus;
  bool interchange_possible = false;

  std::cin >> input_bus;

  if(!schedule.count(input_bus)) {
    std::cout << "No bus" << std::endl;
    return;
  }

  const auto& itinerary = schedule.at(input_bus);

  for(const auto& stop : itinerary) {
    std::cout << "Stop " << stop << ":";

    // Print buses or interchange
    for(const auto& bus : ordered_buses) {
      if(bus == input_bus) {
        continue;
      }

      auto stops = schedule.at(bus);
      if (std::find(stops.begin(), stops.end(), stop) != stops.end()) {
        interchange_possible = true;
        std::cout << " " << bus;
      }
    }

    if(!interchange_possible) {
      std::cout << " no interchange";
    }

    interchange_possible = false;
    std::cout << std::endl;
  }
}

void all_buses(const std::map<std::string, std::vector<std::string>>& schedule) {
  if(schedule.empty()) {
    std::cout << "No buses" << std::endl;
    return;
  }

  for(const auto& bus : schedule) {
    std::cout << "Bus " << bus.first <<  ":";
    for(const auto& stop : bus.second) {
      std::cout << " " << stop;
    }
    std::cout << std::endl;
  }
}

int main() {
  int q;
  std::cin >> q;
  std::map< std::string, std::vector< std::string > > schedule;
  std::vector<std::string> bus_write_order;

  for(int i = 0; i < q; i++) {
    std::string command;

    std::cin >> command;

    if(command == "NEW_BUS") {
      new_bus_handler(schedule, bus_write_order);
    }

    if(command == "BUSES_FOR_STOP") {
      buses_for_stop_handler(schedule, bus_write_order);
    }

    if(command == "STOPS_FOR_BUS") {
      stop_for_bus_handler(schedule, bus_write_order);
    }

    if(command == "ALL_BUSES") {
      all_buses(schedule);
    }
  }

  return 0;
}
