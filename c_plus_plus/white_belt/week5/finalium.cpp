#include <iostream>
#include <string>
#include <map>
#include <sstream>
#include <iomanip>
#include <set>

void EnsureSepratorIsRight(std::stringstream& stream, const std::string& str, const char& separator) {
  if (stream.peek() != separator){
    throw std::invalid_argument("Wrong date format: " + str);
  }
  stream.ignore(1);
}

void EnsureDateFormat(const std::string& str) {
  std::stringstream ss(str);
  int year = 0;
  int month = 0;
  int day = 0;

  ss >> year;

  EnsureSepratorIsRight(ss, str, '-');

  ss >> month;
  if (month <= 0 || month > 12) {
    throw std::runtime_error("Month value is invalid: " + std::to_string(month));
  }

  EnsureSepratorIsRight(ss, str, '-');

  ss >> day;
  if (day <= 0 || day > 31){
    throw std::runtime_error("Day value is invalid: " + std::to_string(day));
  }

  const char& a = str[str.size() - 1];
  if (int(a) < 47 || int(a) > 58) { // ascii for [/ 0..9]
    throw std::invalid_argument("Wrong date format: " + str);
  }
}

class Date {
public:
  Date(const std::string& input_string){
    EnsureDateFormat(input_string);
    std::stringstream ss;
    ss << input_string;
    ss >> year;
    ss.ignore(1);
    ss >> month;
    ss.ignore(1);
    ss >> day;

    std::stringstream ss2;
    ss2 << std::setw(4) << std::setfill('0') << std::to_string(year) << "-"
        << std::setw(2) << std::setfill('0') << std::to_string(month) << "-"
        << std::setw(2) << std::setfill('0') << std::to_string(day);
    ss2 >> date;
  }

  int GetYear() const{
    return year;
  }
  int GetMonth() const{
    return month;
  }
  int GetDay() const{
    return day;
  }
  std::string GetDate() const{
    return date;
  }
private:
  int year = 0;
  int month = 1;
  int day = 1;
  std::string date = "0000-01-01";
};

bool operator<(const Date& lhs, const Date& rhs){
  return lhs.GetYear() * 372 + lhs.GetMonth()*31 + lhs.GetDay() <
    rhs.GetYear() * 372 + rhs.GetMonth()*31 + rhs.GetDay();
}

class Database {
public:
  void AddEvent(const Date& date, const std::string& event){
    database[date].insert(event);
  }

  bool DeleteEvent(const Date& date, const std::string& event){
    for(const auto& e : database[date]) {
      if (e == event) {
        database[date].erase(e);
        return true;
      }
    }
    return false;
  }

  int DeleteDate(const Date& date){
    int count = 0;
    if (database.count(date) == 0){
      return 0;
    } else {
      count = database[date].size();
    }
    database.erase(date);
    return count;
  }

  void Find(const Date& date) const{
    std::set<std::string> events;
    if (database.count(date) > 0) {
      events = database.at(date);
    }
    for (const auto& e : events){
      std::cout << e << std::endl;
    }
  }

  void Print() const{
    for(const auto& date : database){
      for(const auto& event : date.second){
        std::cout << date.first.GetDate() << " "
                  << event << std::endl;
      }
    }
  }
private:
  std::map<Date, std::set<std::string>> database;
};

void CommandParse(const std::string& command, Database& db){
  std::stringstream ss;
  ss << command;
  std::string cmd;
  ss >> cmd;
  if (cmd == "Add"){
    std::string date, event;
    ss >> date >> event;
    EnsureDateFormat(date);
    if (event == ""){
      throw std::invalid_argument("Wrong date format: " + date);
    }
    db.AddEvent({date}, event);

  } else if (cmd == "Print"){
    db.Print();

  } else if (cmd == "Find"){
    std::string date;
    ss >> date;
    db.Find(date);

  } else if (cmd == "Del"){
    std::string date, event;
    ss >> date >> event;
    if (event == ""){
      int n = db.DeleteDate(date);
      std::cout << "Deleted " << n << " events" << std::endl;
    } else {
      if (db.DeleteEvent(date, event)){
        std::cout << "Deleted successfully" << std::endl;
      } else {
        std::cout << "Event not found" << std::endl;
      }
    }

  } else if(cmd == "") {
    // ignore empty line

  } else{
    throw std::runtime_error("Unknown command: " + cmd);
  }
}

int main() {
  Database db;
  std::string command;

  while (getline(std::cin, command)) {
    if (command == "Stop"){
      break;
    }
    try {
      CommandParse(command, db);
    }
    catch (std::exception& e){
      std::cout << e.what() << std::endl;
    }
  }

  return 0;
}
