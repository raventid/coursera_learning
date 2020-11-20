/* https://twitter.com/ImogenBits/status/1325424621286518784 */

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  pid_t pid;
  int pushFd[2];
  int popFd[2];
  int msgFd[2];
} Stack;

typedef enum {
  PUSH,
  POP
} stackMsg;

void stackFunc(Stack *s, int element) {
  stackMsg signal;
  start:
  read(s->msgFd[0], &signal, sizeof signal);

  switch(signal) {
    case PUSH:;
      int newElement;
      read(s->pushFd[0], &newElement, sizeof newElement);
      stackFunc(s, newElement);
      goto start;
    case POP:
      write(s->popFd[1], &element, sizeof element);
      return;
  }
}

void pushElement(Stack *s, int element) {
  write(s->pushFd[1], &element, sizeof element);
  stackMsg signal = PUSH;
  write(s->msgFd[1], &signal, sizeof signal);
}

int popElement(Stack *s) {
  stackMsg signal = POP;
  int element;
  write(s->msgFd[1], &signal, sizeof signal);
  read(s->popFd[0], &element, sizeof element);
  return element;
}

int initStack(Stack *newStack, int firstElement) {
  if (pipe(newStack->pushFd) != 0) {
    return -1;
  }

  if (pipe(newStack->popFd) != 0) {
    return -1;
  }

  if (pipe(newStack->msgFd) != 0) {
    return -1;
  }

  if ((newStack->pid = fork()) == 0) {
    close(newStack->pushFd[1]);
    close(newStack->msgFd[1]);
    close(newStack->popFd[0]);

    stackFunc(newStack, firstElement);

    exit(0);
  } else {
    close(newStack->pushFd[0]);
    close(newStack->msgFd[0]);
    close(newStack->popFd[1]);

    return 0;
  }
}

int main() {
  Stack stack;

  initStack(&stack, 0);

  pushElement(&stack, 1);
  pushElement(&stack, 2);

  int two = popElement(&stack);

  printf("", two);

  return 0;
}
