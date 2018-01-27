// Only for Linux :)
#include <iostream>


// LEVEL TRIGGERED. Notification happens when we have something to read.
// 10 bytes received. System notifies us. We read 5. System notifies us again to read
// another 5.

// EDGE TRIGGERED. Notification happens when we have something to read.
// 10 bytes received. System notifies us. We read 5. System DOES NOT notify us again to read another 5. When next 10 will come, will be notified.


int main() {
  return 0;
}
