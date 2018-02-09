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

Rational operator+(const Rational& left, const Rational& right) {
  int lnumerator, rnumerator, cdenominator;
  if(left.Denominator() != right.Denominator()) {
    lnumerator = left.Numerator() * right.Denominator();
    rnumerator = right.Numerator() * left.Denominator();
    cdenominator = right.Denominator() * left.Denominator();
  } else {
    lnumerator = left.Numerator();
    rnumerator = right.Numerator();
    cdenominator = left.Denominator();
  }

  int numerator = lnumerator + rnumerator;
  int denominator = cdenominator;

  return Rational(numerator, denominator);
}

Rational operator-(const Rational& left, const Rational& right) {
  int lnumerator, rnumerator, cdenominator;
  if(left.Denominator() != right.Denominator()) {
    lnumerator = left.Numerator() * right.Denominator();
    rnumerator = right.Numerator() * left.Denominator();
    cdenominator = right.Denominator() * left.Denominator();
  } else {
    lnumerator = left.Numerator();
    rnumerator = right.Numerator();
    cdenominator = left.Denominator();
  }

  int numerator = lnumerator - rnumerator;
  int denominator = cdenominator;

  return Rational(numerator, denominator);
}



int main() {
  {
    Rational r1(4, 6);
    Rational r2(2, 3);
    bool equal = r1 == r2;
    if (!equal) {
      cout << "4/6 != 2/3" << endl;
      return 1;
    }
  }

  {
    Rational a(2, 3);
    Rational b(4, 3);
    Rational c = a + b;
    bool equal = c == Rational(2, 1);
    if (!equal) {
      cout << "2/3 + 4/3 != 2" << endl;
      return 2;
    }
  }

  {
    Rational a(5, 7);
    Rational b(2, 9);
    Rational c = a - b;
    bool equal = c == Rational(31, 63);
    if (!equal) {
      cout << "5/7 - 2/9 != 31/63" << endl;
      return 3;
    }
  }

  cout << "OK" << endl;
  return 0;
}
