#include <iostream>
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

Rational operator*(const Rational& left, const Rational& right) {
  int numerator = left.Numerator() * right.Numerator();
  int denominator = left.Denominator() * right.Denominator();

  return Rational(numerator, denominator);
}

Rational operator/(const Rational& left, const Rational& right) {
  int numerator = left.Numerator() * right.Denominator();
  int denominator = left.Denominator() * right.Numerator();

  return Rational(numerator, denominator);
}

int main() {
  {
    Rational a(2, 3);
    Rational b(4, 3);
    Rational c = a * b;
    bool equal = c == Rational(8, 9);
    if (!equal) {
      cout << "2/3 * 4/3 != 8/9" << endl;
      return 1;
    }
  }

  {
    Rational a(5, 4);
    Rational b(15, 8);
    Rational c = a / b;
    bool equal = c == Rational(2, 3);
    if (!equal) {
      cout << "5/4 / 15/8 != 2/3" << endl;
      return 2;
    }
  }

  cout << "OK" << endl;
  return 0;
}
