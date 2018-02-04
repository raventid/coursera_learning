#include <iostream>
#include <string>

struct LectureTitle {
public:

private:
  std::string specialization;
  std::string course;
  std::string week;
};

int main() {
  LectureTitle title(
                     Specialization("C++"),
                     Course("White belt"),
                     Week("4th")
                     );

  return 0;
}
