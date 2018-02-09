#include <iostream>
#include <set>
#include <vector>
#include <map>

using namespace std;

class Rational {
public:
  Rational() {
    _numerator = 0;
    _denominator = 1;
  }

  Rational(int numerator, int denominator) {
    if(denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }

    int divisor = common_divisor(numerator, denominator);
    _numerator = numerator / divisor;
    _denominator = denominator / divisor;
  }

  int Numerator() const {
    return _numerator;
  }

  int Denominator() const {
    return _denominator;
  }

private:
  int common_divisor(int a, int b) {
    if (a < 0) { a = -a; }
    if (b < 0) { b = -b; }

    if (a == 0 && b == 0) {
      return 1;
    } else if (a == 0 && b > 0) {
      return b;
    } else if (a > 0 && b == 0) {
      return a;
    }

    while (a != b) {
      if (a > b) {
        a = a - b;
      } else {
        b = b - a;
      }
    }

    if(a == 0) {
      a = 1;
    }

    return a;
  }

  int _numerator, _denominator;
};

// Реализуйте для класса Rational операторы ==, + и -
bool operator==(const Rational& left, const Rational& right) {
  return ((left.Numerator() == right.Numerator()) && (left.Denominator() == right.Denominator()));
}

bool operator<(const Rational& left, const Rational& right) {
  int lnumerator, rnumerator;

  if(left.Denominator() != right.Denominator()) {
    lnumerator = left.Numerator() * right.Denominator();
    rnumerator = right.Numerator() * left.Denominator();
  } else {
    lnumerator = left.Numerator();
    rnumerator = right.Numerator();
  }

  return lnumerator < rnumerator;
}


int main() {
  {
    const set<Rational> rs = {{1, 2}, {1, 25}, {3, 4}, {3, 4}, {1, 2}};
    if (rs.size() != 3) {
      cout << "Wrong amount of items in the set" << endl;
      return 1;
    }

    vector<Rational> v;
    for (auto x : rs) {
      v.push_back(x);
    }
    if (v != vector<Rational>{{1, 25}, {1, 2}, {3, 4}}) {
      cout << "Rationals comparison works incorrectly" << endl;
      return 2;
    }
  }

  {
    map<Rational, int> count;
    ++count[{1, 2}];
    ++count[{1, 2}];

    ++count[{2, 3}];

    if (count.size() != 2) {
      cout << "Wrong amount of items in the map" << endl;
      return 3;
    }
  }

  cout << "OK" << endl;
  return 0;
}
