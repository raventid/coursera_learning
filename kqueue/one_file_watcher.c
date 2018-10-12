// A sample C code to work with kqueue on OS X.
// Here we are using the basic mechanizm. Notifications about file changed.
// Network code is more natural fit for such type of interation, but we don't care about
// this right now.
// Here we are monitoring just one file and print some info about it, while it's changing.
// Next program will demonstrate how to code this up with many files and use real benefit
// of using such a system.

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


/* kevent structure */

/* struct kevent { */
/*   uintptr_t       ident;          /\* identifier for this event *\/ */
/*   int16_t         filter;         /\* filter for event *\/ */
/*   uint16_t        flags;          /\* general flags *\/ */
/*   uint32_t        fflags;         /\* filter-specific flags *\/ */
/*   intptr_t        data;           /\* filter-specific data *\/ */
/*   void            *udata;         /\* opaque user data identifier *\/ */
/* }; */

int main(void)
{
   int f, kq, nev;
   struct kevent change;
   struct kevent event;

   kq = kqueue();

   if (kq == -1)
       perror("kqueue");

   f = open("./foo", O_RDONLY | O_CREAT);

   if (f == -1)
   {
       perror("open");
   }

   EV_SET(&change, f, EVFILT_VNODE,
          EV_ADD | EV_ENABLE | EV_ONESHOT,
          NOTE_DELETE | NOTE_EXTEND | NOTE_WRITE | NOTE_ATTRIB,
          0, 0);

   int events_counter = 0;

   for (;;) {
     // Here we could watch not one, but many files.
     // And handle each event separatly. One by one.
     nev = kevent(kq, &change, 1, &event, 1, NULL);

     if (nev == -1)
       perror("kevent");
     else if (nev > 0)
       events_counter++;
       {
         if (event.fflags & NOTE_DELETE)
           {
             printf("File deleted\n"); //break;
           }
         if (event.fflags & NOTE_EXTEND || event.fflags & NOTE_WRITE)
           printf("%i) File modified\n", events_counter);
         if (event.fflags & NOTE_ATTRIB)
           printf("%i) File attributes modified\n", events_counter);
       }
   }

   close(kq);
   close(f);
   return EXIT_SUCCESS;
}
