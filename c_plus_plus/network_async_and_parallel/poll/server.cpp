#include <iostream>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#include <set>
#include <algorithm>
#include <poll.h>


#define POLL_SIZE 32

int set_nonblock(int fd) {
  int flags;

#if defined(O_NONBLOCK)
  if(-1 == (flags = fcntl(fd, F_GETFL, 0))) {
    flags = 0;
  }
  return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
#else
  flags = 1;
  return ioctl(fd, FIONBIO, &flags);
#endif
}

// This is really weird!
// I see the same error, as with `select`. Server spawns an enourmous amount of messages, without stopping.
// Cool! Something to research!


// With poll we can use any number of sockets, because we set them.
int main() {
  int MasterSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  std::set<int> SlaveSockets;

  struct sockaddr_in SockAddr;
  SockAddr.sin_family = AF_INET;
  SockAddr.sin_port = htons(12345);
  SockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(MasterSocket, (struct sockaddr *)(&SockAddr), sizeof(SockAddr));

  // We need to set socket in non-blocking mode to accept many requests.
  set_nonblock(MasterSocket);

  listen(MasterSocket, SOMAXCONN);

  struct pollfd Set[POLL_SIZE];
  Set[0].fd = MasterSocket;
  Set[0].events = POLL_IN;

  while(true) {

    unsigned int Index = 1;
    for(auto Iter = SlaveSockets.begin(); Iter != SlaveSockets.end(); Iter++) {
      Set[Index].fd = *Iter;
      Set[Index].events = POLL_IN;
      Index++;
    }

    unsigned int SetSize = 1 + SlaveSockets.size();

    poll(Set, SetSize, -1);

    // lldb showed one interesting thing about OS X.
    // recv reads data, but revents on SlaveSocket do not chage. So it's 1.
    // Weird stuff. MasterSocket works fine.

    // trying to debug some crap :)
    for(unsigned int i = 0; i < SetSize; i++) {
      if(Set[i].revents & POLL_IN) {
        if(i) {
          static char Buffer[1024];

          // It works fine this way. Wtf??? Whats wrong with recv, and what's
          // actually going on here?
          int RecvSize = read(Set[i].fd, Buffer, 1024);
          // int RecvSize = recv(Set[i].fd, Buffer, 1024, SO_NOSIGPIPE);
          if ((RecvSize == 0) && (errno != EAGAIN)) {
            shutdown(Set[i].fd, SHUT_RDWR);
            close(Set[i].fd);
            SlaveSockets.erase(Set[i].fd);
          } else if(RecvSize > 0) {
            send(Set[i].fd, Buffer, RecvSize, SO_NOSIGPIPE);
          }
        } else {
          int SlaveSocket = accept(MasterSocket, 0, 0);
          set_nonblock(SlaveSocket);
          SlaveSockets.insert(SlaveSocket);
        }
      }
    }
  }

  return 0;
}
