#include <iostream>
#include <exception>
#include <string>
using namespace std;

string AskTimeServer() {
  return "11:11:11";
}

class TimeServer {
public:
    string GetCurrentTime() {
      try {
        auto response = AskTimeServer();
        LastFetchedTime = response;
      } catch(const system_error& e) {
        // ignore this exception
      }

      return LastFetchedTime;
    }

private:
    string LastFetchedTime = "00:00:00";
};

int main() {
    // Меняя реализацию функции AskTimeServer, убедитесь, что это код работает корректно
    TimeServer ts;
    try {
        cout << ts.GetCurrentTime() << endl;
    } catch (exception& e) {
        cout << "Exception got: " << e.what() << endl;
    }
    return 0;
}
