#include <iostream>
#include <vector>
#include <string>

// Люди стоят в очереди, но никогда не уходят из её начала,
// зато могут приходить в конец и уходить оттуда.
// Более того, иногда некоторые люди могут прекращать и начинать беспокоиться из-за того,
// что очередь не продвигается.

// Реализуйте обработку следующих операций над очередью:

// WORRY i: пометить i-го человека с начала очереди (в нумерации с 0) как беспокоящегося;
// QUIET i: пометить i-го человека как успокоившегося;
// COME k: добавить k спокойных человек в конец очереди;
// COME -k: убрать k человек из конца очереди;
// WORRY_COUNT: узнать количество беспокоящихся людей в очереди.

// Изначально очередь пуста.


// Формат ввода:

// Количество операций Q, затем описания операций.

// Для каждой операции WORRY i и QUIET i гарантируется,
// что человек с номером i существует в очереди на момент операции.

// Для каждой операции COME -k гарантируется, что k не больше текущего размера очереди.

enum state {_WORRY, _QUIET};
enum command {WORRY, QUIET, COME};

void Dispatch(std::vector<state>& v, command command, int attr) {
  switch(command) {
  case COME:
    if (attr > 0) {
      for(int i = 1; i < attr; i++) {
        v.push_back(_QUIET);
      }
    } else {
      for(int i = 1; i < attr; i++) {
        v.erase(v.end() - 1);
      }
    }
    break;
  case WORRY:
    v[attr] = _WORRY;
    break;
  case QUIET:
    v[attr] = _QUIET;
}
}

int WorryCount(const std::vector<state>& q) {
  int result = 0;

  for(auto e : q) {
    if(e == _WORRY) {
      result++;
    }
  }

  return result;
}

int main() {
  int Q;
  std::cin >> Q;

  std::vector<state> queue;
  std::string command;
  int command_attr;

  for(int i = 0; i < Q; i++) {
    std::cin >> command;

    if (command != "WORRY_COUNT") {
      std::cin >> command_attr;
      if (command == "WORRY") {
        Dispatch(queue, WORRY, command_attr);
      }
      if (command == "QUIET") {
        Dispatch(queue, QUIET, command_attr);
      }
      if (command == "COME") {
        Dispatch(queue, COME, command_attr);
      }
    } else {
      std::cout << WorryCount(queue) << std::endl;
    }
  }

  return 0;
}
