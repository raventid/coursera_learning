#include <iostream>
#include <vector>
#include <string>

// У каждого из нас есть ежемесячные дела, каждое из которых нужно выполнять в конкретный день каждого месяца:
// оплата счетов за электричество,
// абонентская плата за связь и пр.

// Вам нужно реализовать работу со списком таких дел, а именно, обработку следующих операций:

// ADD i s

// Добавить дело с названием s в день i.

// NEXT

// Закончить текущий месяц и начать новый.
// Если новый месяц имеет больше дней, чем текущий, добавленные дни изначально не будут содержать дел.
// Если же в новом месяце меньше дней, дела со всех удаляемых дней необходимо будет переместить на последний день нового месяца.

// Обратите внимание, что количество команд этого типа может превышать 11.

// DUMP i


// Вывести все дела в день i.

// Изначально текущим месяцем считается январь.
// Количества дней в месяцах соответствуют Григорианскому календарю с той лишь разницей, что в феврале всегда 28 дней.


// Append v2 to v1:
// v1.insert(end(v1), begin(v2), end(v2));

// Формат ввода:

// Сначала число операций Q, затем описания операций.

// Названия дел s уникальны и состоят только из латинских букв, цифр и символов подчёркивания.
// Номера дней i являются целыми числами и нумеруются от 1 до размера текущего месяца.

// Формат вывода:

// Для каждой операции типа DUMP в отдельной строке выведите количество дел в соответствующий день, а затем их названия, разделяя их пробелом.
// Порядок вывода дел в рамках каждой операции значения не имеет.

int main() {
  int Q;
  std::cin >> Q;

  // 1	Январь	31
  // 2	Февраль	28 (29 — в високосном году)
  // 3	Март	31
  // 4	Апрель	30
  // 5	Май	31
  // 6	Июнь	30
  // 7	Июль	31
  // 8	Август	31
  // 9	Сентябрь	30
  // 10	Октябрь	31
  // 11	Ноябрь	30
  // 12	Декабрь	31

  // warning here because it's c++11 addition, looks like flycheck uses 98/03.
  std::vector<int> months = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

  std::vector< std::vector< std::vector<std::string> > > calendar;
  int selected_month = 0;

  for(int i = 0; i < months.size(); i++) {
    std::vector< std::vector< std::string > > m_data;

    for(int j = 0; j < months[i]; j++) {
      std::vector<std::string> m = {};
      m_data.push_back(m);
    }

    calendar.push_back(m_data);
  }

  for(int i = 0; i < Q; i++) {
    std::string command;
    int dayNumber;
    std::string todoName;

    std::cin >> command;

    if (command == "ADD") {
      std::cin >> dayNumber;
      dayNumber--; // I'm starting day with 0;
      std::cin >> todoName;

      calendar[selected_month][dayNumber].push_back(todoName);
    }

    if (command == "DUMP") {
      std::cin >> dayNumber;
      dayNumber--; // I'm starting days with 0.
      if(!calendar[selected_month][dayNumber].empty()) {
        std::cout << calendar[selected_month][dayNumber].size() << " ";
        for(auto task : calendar[selected_month][dayNumber]) {
          std::cout << task << " ";
        }
      } else {
        std::cout << 0;
      }
      std::cout << std::endl;
    }

    if (command == "NEXT") {
      int next_month = selected_month + 1;

      if(selected_month == 11) {
        next_month = 0;
      }

      {
        calendar[next_month].resize(0);
        std::vector< std::vector< std::string > > m_data;

        for(int j = 0; j < months[next_month]; j++) {
          std::vector<std::string> m = {};
          m_data.push_back(m);
        }

        calendar[next_month] = m_data;
      }

      int days_in_next = calendar[next_month].size();
      int days_in_current = calendar[selected_month].size();

      if(days_in_current <= days_in_next) {
        // just copy everything as it is
        for(int i = 0; i < days_in_current; i++) {
          calendar[next_month][i] = calendar[selected_month][i];
        }
      } else {
        // if next is smaller - copy every element until last element in next
        for(int i = 0; i < days_in_next; i++) {
          calendar[next_month][i] = calendar[selected_month][i];
        }

        // after this append tail to last element in our array
        int difference_in_days = days_in_current - days_in_next;

        for(int i = days_in_next;
            i < days_in_next + difference_in_days;
            i++) {
          // Append v2 to v1:
          calendar[next_month][days_in_next-1]
            .insert(end(calendar[next_month][days_in_next-1]),
                    begin(calendar[selected_month][i]),
                    end(calendar[selected_month][i]));
        }
      }

      selected_month = next_month;
    }
  }

  return 0;
}


// INPUT:

// 12
// ADD 5 Salary
// ADD 31 Walk
// ADD 30 WalkPreparations
// NEXT
// DUMP 5
// DUMP 28
// NEXT
// DUMP 31
// DUMP 30
// DUMP 28
// ADD 28 Payment
// DUMP 28


// OUTPUT:

// 1 Salary
// 2 WalkPreparations Walk
// 0
// 0
// 2 WalkPreparations Walk
// 3 WalkPreparations Walk Payment
