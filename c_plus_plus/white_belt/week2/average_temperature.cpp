#include <iostream>
#include <vector>

// Даны значения температуры, наблюдавшиеся в течение N подряд идущих дней.
// Найдите номера дней (в нумерации с нуля) со значением температуры выше среднего арифметического за все N дней.
// Гарантируется, что среднее арифметическое значений температуры является целым числом.


int ArithmeticMean(const std::vector<int> temperatures) {
  int sum = 0;

  for(auto t : temperatures) {
    sum += t;
  }

  return sum / temperatures.size();
}

int main() {
  int N;
  std::cin >> N;

  std::vector<int> temperatures;

  for(int i = 0; i < N; i++) {
    int temperature;
    std::cin >> temperature;

    temperatures.push_back(temperature);
  }

  int mean = ArithmeticMean(temperatures);
  std::vector<int> answer;

  for(int i = 0; i < temperatures.size(); i++) {
    if(temperatures[i] > mean) {
      answer.push_back(i);
    }
  }

  std::cout << answer.size() << std::endl;
  for (auto a : answer) {
    std::cout << a << " ";
  }

  return 0;
}
