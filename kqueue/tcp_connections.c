#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/event.h>
#include <sys/time.h>
#include <errno.h>

#define BUFFER_SIZE 1024
// wow, awesome, it's a bit hard to read because of vargs and other tricks
// and what does it do after all??????
#define on_error(...) { fprintf(stderr, __VA_ARGS__); fflush(stderr); exit(1); }

// Try to make universal function for making socket non-blocking:
int set_nonblock(int fd) {
  int flags;
#if defined (O_NONBLOCK)

  if (-1 == (flags = fcntl(fd, F_GETFL, 0))) {
    flags = 0;
  }
  return fcntl(fd, F_SETFL, flags | O_NONBLOCK);

#else

  flags = 1;
  return ioctl(fd, FIONBIO, &flags);

#endif
}

static struct kevent *events;
// this is how many events we get from queue in this iteration?
static int events_used = 0;
// this how many event structures we allocated on heap to write data from kernel to
// them? not sure yeat, but think so.
static int events_alloc = 0;

/* struct sockaddr_in { */
/*   sa_family_t    sin_family; /\* address family: AF_INET *\/ */
/*   in_port_t      sin_port;   /\* port in network byte order *\/ */
/*   struct in_addr sin_addr;   /\* internet address *\/ */
/* }; */

/* /\* Internet address. *\/ */
/* struct in_addr { */
/*   uint32_t       s_addr;     /\* address in network byte order *\/ */
/* }; */

static struct sockaddr_in server; // just structure required by socket
static int server_fd, queue; // server file descriptor, queue

// this is the structure for event?
// here will safe a data from queue?
struct event_data {
  char buffer[BUFFER_SIZE];
  int buffer_read;
  int buffer_write;

  // wtf??? how does it work?
  int (*on_read) (struct event_data *self, struct kevent *event);
  int (*on_write) (struct event_data *self, struct kevent *event);
};

static void event_server_listen (int port) {
  int err, flags;

  queue = kqueue();
  if (queue < 0) on_error("Could not create kqueue: %s\n", strerror(errno));

  // PF_INET - ipv4 protocol version, it works with AF_INET somehow :)
  /* A SOCK_STREAM type provides sequenced, reliable, two-way connection based */
  /* byte streams.  An out-of-band data transmission mechanism may be supported. */
  // Third argument is protocol, where 0 means default protocol
  // for SOCK_STREAM it is tcp, and for SOCK_DGRAM it is udp.
  // but we can use exact protocols like IPPROTO_TCP and IPPROTO_UDP.
  server_fd = socket(AF_INET, SOCK_STREAM, 0);

  if (server_fd < 0) on_error("Could not create server socket: %s\n", strerror(errno))

  server.sin_family = AF_INET; // it means ipv4, duplicate of domain in socket call ^
  // host to network. network is big endian. host depends
  server.sin_port = htons(port);
  // htonl is for `uint32_t hostlong` and htons is for `uint16_t hostshort`
  // INADDR_LOOPBACK - 127.0.0.1
  server.sin_addr.s_addr = htonl(INADDR_ANY);

  int opt_val = 1;
  // SOL_SOCKET - options at socket level
  // SO_REUSEADDR - enables local address reuse
  /* SO_REUSEADDR indicates that the rules used in validating addresses sup- */
  /* plied in a bind(2) call should allow reuse of local addresses. */

  // if we make kill, address will be busy for some time after this,
  // so with SO_REUSEADDR we can start our application on the same address without any problem.
  // we can also set timeout here, using setsockopt() like this:
  // struct timeval tv {
  //   tv.tv_sec = 16;
  //   tv.tv_usec = 0;
  // }
  //                           SO_SNDTIMEOUT
  // setsockopt(s, SOL_SOCKET, SO_RCVTIMEOUT, (char *) &tv, sizeof(tv))
  setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt_val, sizeof(opt_val));

  // first is a file descriptor
  // second is our socketaddr struct
  // and third is the size of our socket struct
  err = bind(server_fd, (struct sockaddr *) &server, sizeof(server));
  if (err < 0) on_error("Could not bind server socket: %s\n", strerror(errno));


  // Those two calls just make socket nonblocking, we can use my set_nonblock
  // function written above. But we can stick with this hand-written crap,
  // it also works after all.
  flags = fcntl(server_fd, F_GETFL, 0);
  if (flags < 0) on_error("Could not get server socket flags: %s\n", strerror(errno))

  err = fcntl(server_fd, F_SETFL, flags | O_NONBLOCK);
  if (err < 0) on_error("Could set server socket to be non blocking: %s\n", strerror(errno));

  // SOMAXCONN - maximum amount of request queue length for current OS. usually 128.
  // if queue excedes 128 request, the rest is cut down, sorry (I think it's possible to make this number bigger)
  err = listen(server_fd, SOMAXCONN);
  if (err < 0) on_error("Could not listen: %s\n", strerror(errno));
}

static void event_change (int ident, int filter, int flags, void *udata) {
  struct kevent *e;

  if (events_alloc == 0) {
    events_alloc = 64;
    events = malloc(events_alloc * sizeof(struct kevent));
  }
  if (events_alloc <= events_used) {
    events_alloc *= 2;
    events = realloc(events, events_alloc * sizeof(struct kevent));
  }

  int index = events_used++;
  e = &events[index];

  e->ident = ident;
  e->filter = filter;
  e->flags = flags;
  e->fflags = 0;
  e->data = 0;
  e->udata = udata;
}

static void event_loop () {
  int new_events;

  while (1) {
    new_events = kevent(queue, events, events_used, events, events_alloc, NULL);
    if (new_events < 0) on_error("Event loop failed: %s\n", strerror(errno));
    events_used = 0;

    for (int i = 0; i < new_events; i++) {
      struct kevent *e = &events[i];
      struct event_data *udata = (struct event_data *) e->udata;

      if (udata == NULL) continue;
      if (udata->on_write != NULL && e->filter == EVFILT_WRITE) while (udata->on_write(udata, e));
      if (udata->on_read != NULL && e->filter == EVFILT_READ) while (udata->on_read(udata, e));
    }
  }
}

static int event_flush_write (struct event_data *self, struct kevent *event) {
  int n = write(event->ident, self->buffer + self->buffer_write, self->buffer_read - self->buffer_write);

  if (n < 0) {
    if (errno == EWOULDBLOCK || errno == EAGAIN) return 0;
    on_error("Write failed (should this be fatal?): %s\n", strerror(errno));
  }

  if (n == 0) {
    free(self);
    close(event->ident);
    return 0;
  }

  self->buffer_write += n;

  if (self->buffer_write == self->buffer_read) {
    self->buffer_read = 0;
    self->buffer_write = 0;
  }

  return 0;
}

static int event_on_read (struct event_data *self, struct kevent *event) {
  if (self->buffer_read == BUFFER_SIZE) {
    event_change(event->ident, EVFILT_READ, EV_DISABLE, self);
    return 0;
  }

  int n = read(event->ident, self->buffer + self->buffer_read, BUFFER_SIZE - self->buffer_read);

  if (n < 0) {
    if (errno == EWOULDBLOCK || errno == EAGAIN) return 0;
    on_error("Read failed (should this be fatal?): %s\n", strerror(errno));
  }

  if (n == 0) {
    free(self);
    close(event->ident);
    return 0;
  }

  if (self->buffer_read == 0) {
    event_change(event->ident, EVFILT_WRITE, EV_ENABLE, self);
  }

  self->buffer_read += n;
  return event_flush_write(self, event);
}

static int event_on_write (struct event_data *self, struct kevent *event) {
  if (self->buffer_read == self->buffer_write) {
    event_change(event->ident, EVFILT_WRITE, EV_DISABLE, self);
    return 0;
  }

  return event_flush_write(self, event);
}

static int event_on_accept (struct event_data *self, struct kevent *event) {
  struct sockaddr client;
  socklen_t client_len = sizeof(client);

  // client will collect client data (ip and port), client_len is length for this
  // structure.
  // in return we get client_socket descriptor (client will use this socket to do it's job)
  int client_fd = accept(server_fd, &client, &client_len);
  int flags;
  int err;

  if (client_fd < 0) {
    if (errno == EWOULDBLOCK || errno == EAGAIN) return 0;
    on_error("Accept failed (should this be fatal?): %s\n", strerror(errno));
  }

  flags = fcntl(client_fd, F_GETFL, 0);
  if (flags < 0) on_error("Could not get client socket flags: %s\n", strerror(errno));

  err = fcntl(client_fd, F_SETFL, flags | O_NONBLOCK);
  if (err < 0) on_error("Could not set client socket to be non blocking: %s\n", strerror(errno));

  struct event_data *client_data = (struct event_data *) malloc(sizeof(struct event_data));
  client_data->on_read = event_on_read;
  client_data->on_write = event_on_write;

  event_change(client_fd, EVFILT_READ, EV_ADD | EV_ENABLE, client_data);
  event_change(client_fd, EVFILT_WRITE, EV_ADD | EV_ENABLE, client_data);

  return 1;
}

int main (int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s [port]\n", argv[0]);
    exit(1);
  }

  int port = atoi(argv[1]);

  struct event_data server = {
    .on_read = event_on_accept,
    .on_write = NULL
  };

  event_server_listen(port);
  event_change(server_fd, EVFILT_READ, EV_ADD | EV_ENABLE, &server);
  event_loop();

  return 0;
}

