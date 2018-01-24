#include <iostream>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#include <set>
#include <algorithm>
#include <sys/select.h>

// under OS X this program dies with `illegal instruction: 4`, which is weird
// cause I see just a couple of warnings from clang and it compiles nicely to binary
// and I'm running it on the *same* machine I compile it. Weird!

// TODO: Run this crap in Docker(Linux) and see if it works.
// Perhaps OS X protects me from segfault?(with `illegal instruction 4`)
// Looks like this is the case, but is it segfaulting on Linux?
// for(auto I : SlaveSockets) with empty sockets will segfault.

// Checked on Linux, with minimal tweaks it works fine. Problem is OS X. Well
// it will be extremly cool to find out what is wrong!

// Wrapped some parts of code into `counter` check. Problem is in range-based `for` it works
// the wrong way(as far as I see, right now).

// Current problem is select, it spams client with `send`, how does it work?
// maybe some smart OS X socket caching??? Is there anything like that here?
// Maybe problem is that I'm using `sys/select.h`? Perhaps it's out of date?

// UPD:
// TODO: Find some Rust bindings to work with `select`. Implement the same stuff.

// TODO: Rewrite this in plain C. Recompile with clang.

// TODO: Recompile in 32bit mode. Wow!!!!

// PCI-D cache optimization

// TODO: Try blocking to inscrease cache.

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

// Maximum select pull - 1024 descriptors.
// Select
int main(int argc, char **argv) {
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

  int count = 0;
  fd_set Set; // 1024 bits

  while(true) {
    FD_ZERO(&Set);
    FD_SET(MasterSocket, &Set);

    if (count > 0) {
      for(auto Iter : SlaveSockets) {
        FD_SET(Iter, &Set);
      }
    }


    int Max = 0;

    if (count > 0) {
      Max = std::max(MasterSocket, *std::max_element(SlaveSockets.begin(), SlaveSockets.end()));
    } else {
      Max = MasterSocket;
    }

    count++;
    // select will block us. after it will unblock will get our 1024 bits set
    // with the next information:
    // 1 - if there is some activity on socket and 0 if there is no
    select(Max + 1, &Set, NULL, NULL, NULL);

    for(auto Iter : SlaveSockets) {
      if(FD_ISSET(Iter, &Set)) {
        static char Buffer[1024];
        int RecvSize = recv(Iter, Buffer, 1024, SO_NOSIGPIPE);
        // if 0 then we could read nothing if eagain, then we cannot read because OS
        // asked us to repeat read. Well let's reapeat it.
        if((RecvSize == 0) && (errno != EAGAIN)) {
          shutdown(Iter, SHUT_RDWR);
          close(Iter);
          SlaveSockets.erase(Iter);
        } else if(RecvSize != 0) {
          // we got something, let's read it and return back to client
          send(Iter, Buffer, RecvSize, SO_NOSIGPIPE);
        }
      }
    }

    if(FD_ISSET(MasterSocket, &Set)) {
      int SlaveSocket = accept(MasterSocket, 0, 0);
      set_nonblock(SlaveSocket);
      SlaveSockets.insert(SlaveSocket);
    }
  }
  // create set of file descriptors
  // fd_set Set;
  // Nullify socket.
  // FD_ZERO(&Set);
  // Add master socket to set
  // FD_SET(MasterSocket, &Set);
  // for(...) { add_slave(); }

  // As select is simply an array of bytes we would love to avoid running through
  // it every time we want to work with sockets. So we need to find a MAX(posinioned) socket.

  // int Max = maximal descriptor

  // now we are doing select call


  // From man:
  /* int */
  /*   select(int nfds, fd_set *restrict readfds, fd_set *restrict writefds, */
  /*          fd_set *restrict errorfds, struct timeval *restrict timeout); */


  // Copypaste from smart comment:
  /* По поводу таймаута: */

  /* Если он NULL - select() будет блокирующим. Если в структуру таймаута записать 0 - будет неблокирующим. Если установлен таймаут - select будет ждать до таймаута. Причем в некоторых реализациях значение таймаута обновляется селектом и в него пишется время, оставшееся до таймаута, соответственно, при новом обращении к select() нужно структуру таймаута обновить, записав в нее свежее значение требуемого таймаута. А в некоторых реализациях таймаут не изменяется. */

  // select(MAX + 1, &Set, NULL, NULL, NULL)

  // for(...)
  /* { */
  /*   if(FD_ISSET(iter)) { */
  /*      send_message... */
  /*   } */

  /*   if(FD_ISSET(MasterSocket)) { */
  /*     accept... */
  /*   } */
  /* } */
  return 0;
}
