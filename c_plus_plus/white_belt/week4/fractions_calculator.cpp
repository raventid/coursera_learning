#include <iostream>
#include <exception>
using namespace std;

class Rational {
public:
  Rational() {
    _numerator = 0;
    _denominator = 1;
  }

  Rational(int numerator, int denominator) {
    if (denominator == 0) {
      throw invalid_argument("denominator is 0");
    }

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

Rational operator*(const Rational& left, const Rational& right) {
  int numerator = left.Numerator() * right.Numerator();
  int denominator = left.Denominator() * right.Denominator();

  return Rational(numerator, denominator);
}

Rational operator/(const Rational& left, const Rational& right) {
  if(right.Denominator() == 0 || right.Numerator() == 0) { throw domain_error("Oops"); }

  int numerator = left.Numerator() * right.Denominator();
  int denominator = left.Denominator() * right.Numerator();

  return Rational(numerator, denominator);
}

ostream& operator<<(ostream& stream, const Rational& r) {
  stream << r.Numerator() << "/" << r.Denominator();
  return stream;
}

istream& operator>>(istream& stream, Rational& r) {
  int numerator = 0, denominator = 0;

  stream >> numerator;
  stream.ignore(1);
  stream >> denominator;

  r = Rational(numerator, denominator);

  return stream;
}


int main() {
  Rational left, right;
  string command;

  try {
    cin >> left >> command >> right;
  } catch(const exception& e) {
    cout << "Invalid argument";
    return 0;
  }

  if(command == "+") {
    cout << left + right;
  } else if(command == "-") {
    cout << left - right;
  } else if(command == "*") {
    cout << left * right;
  } else {
    try {
      cout << left / right;
    } catch(const exception& e) {
      cout << "Division by zero";
    }
  }

  return 0;
}
