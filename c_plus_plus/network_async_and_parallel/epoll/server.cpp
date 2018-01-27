// Only for Linux :)
// So we'll use Docker to compile this on OS X.
#include <iostream>
#include <algorithm>
#include <set>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/epoll.h>

#define MAX_EVENTS 32

int set_nonblock(int fd) {
  int flags;

  if (-1 == (flags = fcntl(fd, F_GETFL, 0))) {
    flags = 0;
  }

  return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}


// LEVEL TRIGGERED. Notification happens when we have something to read.
// 10 bytes received. System notifies us. We read 5. System notifies us again to read
// another 5.

// EDGE TRIGGERED. Notification happens when we have something to read.
// 10 bytes received. System notifies us. We read 5. System DOES NOT notify us again to read another 5. When next 10 will come, will be notified.


int main() {

  int MasterSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

  struct sockaddr_in SockAddr;
  SockAddr.sin_family = AF_INET;
  SockAddr.sin_port = htons(12345);
  SockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(MasterSocket, (struct sockaddr *)(&SockAddr), sizeof(SockAddr));

  set_nonblock(MasterSocket);

  listen(MasterSocket, SOMAXCONN);

  // Epoll descriptor;
  int Epoll = epoll_create1(0);

  // This block is used to create epoll event to register
  // any socket.
  struct epoll_event Event;
  Event.data.fd = MasterSocket;
  Event.events = EPOLLIN;

  epoll_ctl(Epoll, EPOLL_CTL_ADD, MasterSocket, &Event);


  while(true) {
    // Create array of events
    struct epoll_event Events[MAX_EVENTS];
    int N = epoll_wait(Epoll, Events, MAX_EVENTS, -1);

    for(unsigned int i = 0; i < N; i++) {
      if(Events[i].data.fd == MasterSocket) {
        int SlaveSocket = accept(MasterSocket, 0, 0);
        set_nonblock(SlaveSocket);

        struct epoll_event Event;
        Event.data.fd = SlaveSocket;
        Event.events = EPOLLIN;

        // We don't need any Set to save SlaveSockets
        // because we already have internal epoll storage
        // to watch for our resources. Yay!
        epoll_ctl(Epoll, EPOLL_CTL_ADD, SlaveSocket, &Event);
      } else {
        static char Buffer[1024];
        int RecvResult = recv(Events[i].data.fd, Buffer, 1024, 0);
        if ((RecvResult == 0) && (errno != EAGAIN)) {
          shutdown(Events[i].data.fd, SHUT_RDWR);
          close(Events[i].data.fd);
        } else if (RecvResult > 0) {
          send(Events[i].data.fd, Buffer, RecvResult, MSG_NOSIGNAL);
        }
      }
    }
  }

  return 0;
}
