#include <iostream>
#include <string>

struct LinkedStackOfStrings {
    struct Node {
        std::string item;
        Node next;

        Node(std::string s) {
          item = s;
        }
    };

  Node n;
};
