// Chapter 4. Kleisli category.

#include <math.h>
#include <iostream>

template<class A>
class optional {
  bool _isValid;
  A _value;
public:
  optional() : _isValid(false) {}
  optional(A v) : _isValid(true), _value(v) {}
  bool isValid() const { return _isValid; }
  A value() const { return _value; }
};

optional<double> safe_root(double x) {
  if (x >= 0) {
    return optional<double>{sqrt(x)};
  } else {
    return optional<double>{};
  }
}

optional<double> reciprocal(double x) {
  if (x >= 0) {
    return optional<double>(1/x);
  } else {
    return optional<double>{};
  }
}

// To construct Kleisli from above snippets I need identity + composition
auto const compose = [](auto f, auto g) {
                       return [f, g](auto x) {
                                auto res1 = f(x);
                                if (res1.isValid()) {
                                  return g(res1.value());
                                } else {
                                  return res1;
                                }
                              };
                     };

optional<double> safe_root_reciprocal(double x) {
  return compose(reciprocal, safe_root)(x);
}

int main() {
  auto val = safe_root_reciprocal(10.0);
  if (val.isValid()) {
    std::cout << "Value is " << val.value();
  } else {
    std::cout << "Option is None";
  }
}
