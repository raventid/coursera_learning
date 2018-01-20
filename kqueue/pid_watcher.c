// Simple pid watcher, it's a next step in my kqueue learning

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/event.h>
#include <sys/time.h>
#include <errno.h>
#include <string.h>
#include <inttypes.h>
#include <limits.h>
#include <errno.h>

/* Helper function */

#define INVALID 	1
#define TOOSMALL 	2
#define TOOLARGE 	3

long long
strtonum(const char *numstr, long long minval, long long maxval,
         const char **errstrp)
{
  long long ll = 0;
  char *ep;
  int error = 0;
  struct errval {
    const char *errstr;
    int err;
  } ev[4] = {
    { NULL,		0 },
    { "invalid",	EINVAL },
    { "too small",	ERANGE },
    { "too large",	ERANGE },
  };

  ev[0].err = errno;
  errno = 0;
  if (minval > maxval)
    error = INVALID;
  else {
    ll = strtoll(numstr, &ep, 10);
    if (numstr == ep || *ep != '\0')
      error = INVALID;
    else if ((ll == LLONG_MIN && errno == ERANGE) || ll < minval)
      error = TOOSMALL;
    else if ((ll == LLONG_MAX && errno == ERANGE) || ll > maxval)
      error = TOOLARGE;
  }
  if (errstrp != NULL)
    *errstrp = ev[error].errstr;
  errno = ev[error].err;
  if (error)
    ll = 0;

  return (ll);
}


int main(int argc, char **argv) {
  int kq;
  struct kevent kev; // the kevent structure, container for messages from kernel queue
  pid_t pid; // object we are interested in

  /* pid = strtonum(argv[1], 0, 10000, NULL); // str -> number */
  // looks like I failed to write strtonum, so it does not work.
  // second kevent does not work either, program just exits without any sign of
  // anything. I should really learn to debug with GDB, LLDB :)
  pid = 57348;
  kq = kqueue();

  // this is the way to initialize kevent structure
  // EVFILT_PROC - our target is a process
  // EV_ADD - we would like to add it to queue
  // NOTE_EXIT - we are interested in EXIT event (I think it is the death of process?)
  EV_SET(&kev, pid, EVFILT_PROC, EV_ADD, NOTE_EXIT, 0, NULL);

  /* int */
  /*   kevent(int kq, const struct kevent *changelist, int nchanges, */
  /*          struct kevent *eventlist, int nevents, */
  /*          const struct timespec *timeout); */

  // changelist is monitored object kernel should add to it's monitoring list
  // eventlist is space for kernel to write events
  kevent(kq, &kev, 1, NULL, 0, NULL); // registering object for kqueue
  printf("pid is %i", pid);
  kevent(kq, NULL, 0, &kev, 0, NULL); // query object

  return 0;
}

/* Now that we understand a bit about how kqueue works, we are in a position */
/* to learn some more about its sharp edges. As anyone familiar with select or */
/* poll and tell you, you may repeatedly call those functions and receive more or */
/* less the same results every time.  If a socket has data available for reading, */
/* poll will return it. If you don’t read from the socket and call poll again, it is */
/* still readable and poll will again return it. This is not the case with kqueue. */
/* The first call to kqueue will indicate the socket is ready for reading, but the */
/* second will not. Why not? Between the calls to kqueue, the socket’s state has */
/* not changed. kqueue only records changes in state, it never actually reads the */
/* current state. To do so would mean returning to poll levels of scalability. The */
/* precise defintion of what constitutes a state change depends on the object. In */
/* the case of sockets, "available to read" is marked whenever new data arrives. */
/* So your code may work fine in testing if the other end of the socket writes more */
/* data between your kqueue calls, but once released into the variety of real world */
/* network situations the code will appear to hang. Be careful! */


