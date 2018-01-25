#include <array>
#include <cassert>
#include <iostream>
#include <set>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>


// On Mac OS X it after connecting with client this crap start to spawn enourmous
// amount of messages to the client. (Tested with telnet). So it looks like it is
// infinite loop.

// Great. Great. Simple select version falls with `illegal instruction: 4` somewhere
// near FD_SET() after first master socket and this one is just infinite loop! Awesome.

namespace {

const int kPort = 12345;
const int kReadBufferSize = 1024;

} // namespace

int set_nonblock(int fd)
{
    int flags;
#if defined(O_NONBLOCK)
    if (-1 == (flags = fcntl(fd, F_GETFL, 0))) {
        flags = 0;
    }
    return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
#else
    flags = 1;
    return ioctl(fd, FIOBIO, &flags);
#endif
}

int maxSocketId(int serverSocket, const std::set<int>& clientSockets)
{
    if (clientSockets.empty()) {
        return serverSocket;
    } else {
        return std::max(serverSocket, *clientSockets.rbegin());
    }
}

// returns server socket descriptor
int startListening(int port)
{
    int serverSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (serverSocket == -1) {
        std::cerr << "cannot open socket\n";
        return -1;
    }

    struct sockaddr_in sockAddr;
    sockAddr.sin_family = AF_INET;
    sockAddr.sin_port = htons(port);
    sockAddr.sin_addr.s_addr = htonl(INADDR_ANY);

    int ret = bind(serverSocket, (struct sockaddr *)(&sockAddr), sizeof(sockAddr));
    if (ret == -1) {
        std::cerr << "failed to bind socket\n";
        return -1;
    }

    ret = set_nonblock(serverSocket);
    if (ret == -1) {
        std::cerr << "failed to set non-blocking mode\n";
        return -1;
    }

    ret = listen(serverSocket, SOMAXCONN);
    if (ret == -1) {
        std::cerr << "failed to set non-blocking mode\n";
        return -1;
    }
    return serverSocket;
}

int main()
{
    int serverSocket = startListening(kPort);
    if (serverSocket == -1) {
        std::cerr << "invalid socket\n";
        return 1;
    }

    std::set<int> clientSockets;

    fd_set fds;
    while (true) {
        FD_ZERO(&fds);
        FD_SET(serverSocket, &fds);

        for (auto sock: clientSockets) {
            FD_SET(sock, &fds);
        }

        int max = maxSocketId(serverSocket, clientSockets);
        select(max + 1, &fds, nullptr, nullptr, nullptr);

        auto it = clientSockets.begin();
        while (it != clientSockets.end()) {
            int sock = *it;
            if (FD_ISSET(sock, &fds)) {
                std::array<char, kReadBufferSize> buf;
                int nRead = recv(sock, buf.data(), kReadBufferSize, SO_NOSIGPIPE);
                if (nRead <= 0 && errno != EAGAIN) {
                    shutdown(sock, SHUT_RDWR);
                    close(sock);
                    it = clientSockets.erase(it);
                } else if (nRead > 0) {
                    send(sock, buf.data(), nRead, SO_NOSIGPIPE);
                    ++it;
                } else {
                    ++it;
                }
            } else {
                ++it;
            }
        }
        if (FD_ISSET(serverSocket, &fds)) {
            int sock = accept(serverSocket, 0, 0);
            if (sock == -1) {
                std::cerr << "accept error\n";
                return 1;
            }
            set_nonblock(sock);
            clientSockets.insert(sock);
        }
    }

    return 0;
}
