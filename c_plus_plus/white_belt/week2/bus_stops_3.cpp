#include <iostream>
#include <vector>
#include <map>
#include <string>
#include <set>

int main() {
  int q;
  std::cin >> q;

  std::map<std::set<std::string>, int> schedule;

  for(int i = 0; i < q; i++) {
    int num_of_stops;
    std::set<std::string> stops;

    std::cin >> num_of_stops;

    for(int j = 0; j < num_of_stops; j++) {
      std::string stop;
      std::cin >> stop;

      stops.insert(stop);
    }

    if(schedule.count(stops)) {
      std::cout << "Already exists for " << schedule[stops] << std::endl;
    } else {
      auto val = schedule.size() + 1;
      schedule[stops] = val;
      std::cout << "New bus " << val << std::endl;
    }
  }

  return 0;
}

