// Only for Linux :)
// So we'll use Docker to compile this on OS X.
#include <iostream>
#include <algorithm>
#include <set>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet.h>
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

  while(true) {
    for() {
      
    }
  }

  return 0;
}
