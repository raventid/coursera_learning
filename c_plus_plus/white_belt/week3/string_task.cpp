#include <iostream>
#include <string>

class ReversibleString {
public:
  ReversibleString() {
    _str = "";
  }

  ReversibleString(const std::string& str) {
    _str = str;
  }

  std::string ToString() const {
    return _str;
  }

  void Reverse() {
    std::reverse(std::begin(_str), std::end(_str));
  }
private:
  std::string _str;
};

// int main() {
//   ReversibleString s("live");
//   s.Reverse();
//   std::cout << s.ToString() << std::endl;

//   s.Reverse();
//   const ReversibleString& s_ref = s;
//   std::string tmp = s_ref.ToString();
//   std::cout << tmp << std::endl;

//   ReversibleString empty;
//   std::cout << '"' << empty.ToString() << '"' << std::endl;

//   return 0;
// }
