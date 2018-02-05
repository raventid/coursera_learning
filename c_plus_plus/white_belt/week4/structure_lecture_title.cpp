#include <iostream>
#include <string>


struct Specialization {
  std::string value;
  explicit Specialization(std::string title) {
    value = title;
  }
};

struct Course {
  std::string value;
  explicit Course(std::string title) {
    value = title;
  }
};

struct Week {
  std::string value;
  explicit Week(std::string number) {
    value = number;
  }
};

struct LectureTitle {
public:
  LectureTitle(Specialization s, Course c, Week w) {
    specialization = s.value;
    course = c.value;
    week = w.value;
  }

  // had to remove `private:` cause Yandex grader didn't see those fields
  std::string specialization;
  std::string course;
  std::string week;
};

// int main() {
//   LectureTitle title(
//                      Specialization("C++"),
//                      Course("White belt"),
//                      Week("4th")
//                      );

//   return 0;
// }
