#include <iostream>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/event.h>
#include <unistd.h>

int set_nonblock(int fd) {
  int flags = 0;

  if (-1 == (flags = fcntl(fd, F_GETFL, 0))) {
    flags = 0;
  }

  return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

int main () {
  int MasterSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);

  struct sockaddr_in SockAddr;
  SockAddr.sin_family = AF_INET;
  SockAddr.sin_port = htons(12345);
  SockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(MasterSocket, (struct sockaddr *)(&SockAddr), sizeof(SockAddr));

  set_nonblock(MasterSocket);

  listen(MasterSocket, SOMAXCONN);

  int Kqueue = kqueue();

  struct kevent KEvent;

  bzero(&KEvent, sizeof(KEvent));

  EV_SET(&KEvent, MasterSocket, EVFILT_READ, EV_ADD, 0, 0, 0);

  kevent(Kqueue, &KEvent, 1, NULL, 0, NULL);

  while(true) {
    bzero(&KEvent, sizeof(KEvent));
    kevent(Kqueue, NULL, 0, &KEvent, 1, NULL);

    if(KEvent.filter == EVFILT_READ) {
      if(KEvent.ident == MasterSocket) {
        int SlaveSocket = accept(MasterSocket, 0, 0);
        set_nonblock(SlaveSocket);

        bzero(&KEvent, sizeof(KEvent));
        EV_SET(&KEvent, SlaveSocket, EVFILT_READ, EV_ADD, 0, 0, 0);

        kevent(Kqueue, &KEvent, 1, NULL, 0, NULL);
      } else {
        static char Buffer[1024];

        int RecvSize = recv(KEvent.ident, Buffer, 1024, 0);

        if (RecvSize <= 0) {
          close(KEvent.ident);
        } else {
          // Still not found MSG_NOSIGNAL for OS X.
          send(KEvent.ident, Buffer, RecvSize, 0);
        }
      }
    }
  }

  return 0;
}
