#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

int main() {

  int Socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

  struct sockaddr_in SockAddr;
  SockAddr.sin_family = AF_INET;
  SockAddr.sin_port = htons(12345);
  SockAddr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

  connect(Socket, (struct sockaddr *)(&SockAddr), sizeof(SockAddr));

  char Buffer[] = "PING";
  send(Socket, Buffer, 4, SO_NOSIGPIPE);

  // MSG_WAITALL <- with this socket will wait 4 bytes and will block execution
  // before it will get it.
  recv(Socket, Buffer, 4, SO_NOSIGPIPE);

  shutdown(Socket, SHUT_RDWR);
  close(Socket);

  printf("%s\n", Buffer);

  return 0;
}
