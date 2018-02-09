#include <iostream>
#include <sstream>
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

ostream& operator<<(ostream& stream, const Rational& r) {
  stream << r.Numerator() << "/" << r.Denominator();
  return stream;
}

istream& operator>>(istream& stream, Rational& r) {
  int numerator = 0, denominator = 0;

  stream >> numerator;
  stream.ignore(1);
  stream >> denominator;

  if(denominator != 0) {
    r = Rational(numerator, denominator);
  }

  return stream;
}

int main() {
    {
        ostringstream output;
        output << Rational(-6, 8);
        if (output.str() != "-3/4") {
            cout << "Rational(-6, 8) should be written as \"-3/4\"" << endl;
            return 1;
        }
    }

    {
        istringstream input("5/7");
        Rational r;
        input >> r;
        bool equal = r == Rational(5, 7);
        if (!equal) {
            cout << "5/7 is incorrectly read as " << r << endl;
            return 2;
        }
    }

    {
        istringstream input("5/7 10/8");
        Rational r1, r2;
        input >> r1 >> r2;
        bool correct = r1 == Rational(5, 7) && r2 == Rational(5, 4);
        if (!correct) {
            cout << "Multiple values are read incorrectly: " << r1 << " " << r2 << endl;
            return 3;
        }

        input >> r1;
        input >> r2;
        correct = r1 == Rational(5, 7) && r2 == Rational(5, 4);
        if (!correct) {
            cout << "Read from empty stream shouldn't change arguments: " << r1 << " " << r2 << endl;
            return 4;
        }
    }

    cout << "OK" << endl;
    return 0;
}
