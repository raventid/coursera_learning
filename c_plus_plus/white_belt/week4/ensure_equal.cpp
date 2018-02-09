#include <iostream>
#include <string>

using namespace std;

void EnsureEqual(const string& left, const string& right) {
  if(left != right) {
    string msg = left;
    msg += " != ";
    msg += right;
    throw runtime_error(msg);
  }
}

int main() {
  try {
    EnsureEqual("C++ White", "C++ White");
    EnsureEqual("C++ White", "C++ Yellow");
  } catch (runtime_error& e) {
    cout << e.what() << endl;
  }
  return 0;
}
