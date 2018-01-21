#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

int main() {
  int MasterSocket = socket(AF_INET,
                            SOCK_STREAM,
                            IPPROTO_TCP);

  struct sockaddr_in SockAddr;
  SockAddr.sin_family = AF_INET;
  SockAddr.sin_port = htons(12345);
  SockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(MasterSocket, (struct sockaddr_in *)(&SockAddr), sizeof(SockAddr));

  listen(MasterSocket, SOMAXCONN);

  while(1) {
    int SlaveSocket = accept(MasterSocket, 0, 0);
    int Buffer[5] = { 0, 0, 0, 0, 0 };
    // MSG_NOSIGNAL is not portable, OS X uses SO_NOSIGPIPE instead
    // well, no problem, let it be. it's the same thing to avoid SIGPIPE.
    // Looks like you don't need SO_NOSIGPIPE for recv, it makes sense only for the
    // send.
    recv(SlaveSocket, Buffer, 4, SO_NOSIGPIPE);
    send(SlaveSocket, Buffer, 4, SO_NOSIGPIPE);

    // Not sure, but do we really need shutdown if we use close?
    // shutdown makes sense if we wanna close RD or WR parts of socket.
    shutdown(SlaveSocket, SHUT_RDWR);
    close(SlaveSocket);

    printf("%s\n", Buffer);
  }

  return 0;
}
