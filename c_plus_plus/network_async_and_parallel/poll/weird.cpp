#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#include <set>
#include <poll.h>


#define POLL_SIZE 32

int set_nonblock(int fd) {
  int flags;

  if(-1 == (flags = fcntl(fd, F_GETFL, 0))) {
    flags = 0;
  }

  return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

int main() {

  int master_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

  std::set<int> slave_sockets;

  struct sockaddr_in SockAddr;
  SockAddr.sin_family = AF_INET;
  SockAddr.sin_port = htons(12345);
  SockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(master_socket, (struct sockaddr *)(&SockAddr), sizeof(SockAddr));

  set_nonblock(master_socket);

  listen(master_socket, SOMAXCONN);

  struct pollfd set[POLL_SIZE];
  set[0].fd = master_socket;
  set[0].events = POLL_IN;

  while(true) {

    unsigned int index = 1;
    for(auto iter = slave_sockets.begin(); iter != slave_sockets.end(); iter++) {
      set[index].fd = *iter;
      set[index].events = POLL_IN;
      index++;
    }

    unsigned int set_size = 1 + slave_sockets.size();

    poll(set, set_size, -1);

    for(unsigned int i = 0; i < set_size; i++) {
      if(set[i].revents & POLL_IN) {
        if(i) {

          static char buffer[1024];

          // This line works as expected.
          // int recv_size = read(set[i].fd, buffer, 1024);

          // This line sends messages in infinite loop?
          // I'm checking this with `telnet 127.0.0.1 12345`

          // We don't need MSG_NOSIGNAL for recv, it's possible only for send.
          int recv_size = recv(set[i].fd, buffer, 1024, 0);

          if ((recv_size == 0) && (errno != EAGAIN)) {
            shutdown(set[i].fd, SHUT_RDWR);
            close(set[i].fd);
            slave_sockets.erase(set[i].fd);
          } else if(recv_size > 0) {
            // MSG_NOSIGNAL does not exists on OS X and looks like SO_NOSIGPIPE
            // is not the right thing to do in OS X. It's a socket flag BTW.
            send(set[i].fd, buffer, recv_size, 0);
          }
        } else {
          int slave_socket = accept(master_socket, 0, 0);
          set_nonblock(slave_socket);
          slave_sockets.insert(slave_socket);
        }
      }
    }
  }

  return 0;
}
