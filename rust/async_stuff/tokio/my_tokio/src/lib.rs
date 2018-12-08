extern crate libc;

use std::net::UdpSocket;

use libc::{fd_set, select, timeval, FD_ISSET, FD_SET, FD_ZERO};

fn main() {
    let sock = UdpSocket::bind("0.0.0.0:5546").expect("Failed to bind socket");
    sock.set_nonblocking(true).expect("Failed to enter non-blocking mode");

    // Here's your udp_socket, it should be polled with select syscall (bad wording, yeah).

    loop {
        // Timeout before next even loop iteration.
        let mut timeval = timeval {
            tv_sec: 1,
            tv_usec: 0,
        };

        // From official documentation:
        // Creates a value whose bytes are all zero.

        // This has the same effect as allocating space with mem::uninitialized
        // and then zeroing it out.
        // It is useful for FFI sometimes, but should generally be avoided.

        // There is no guarantee that an all-zero byte-pattern represents a valid value
        // of some type T.
        // If T has a destructor and the value is destroyed (due to a panic or the end of a scope)
        // before being initialized, then the destructor will run on zeroed data,
        // likely leading to undefined behavior.

        // See also the documentation for mem::uninitialized, which has many of the same caveats.
        let mut read_fds: fd_set = unsafe { std::mem::zeroed() };
        let mut write_fds: fd_set = unsafe { std::mem::zeroed() };

        // Initializes the file descriptor set fdset to have zero bits for all file descriptors.
        // We do this for both read and write sets.
        unsafe { FD_ZERO(&mut read_fds) };
        unsafe { FD_ZERO(&mut write_fds) };

        // Is this amount of file descriptors we need???
        let mut nfds = 0;

        // add read interests to read fd_sets
        // explain what we actually do here

        // add write interests to write fd_sets
        // explain what are you doing one more time


        // select syscall

        // work with potential errors

        // this is all I should do for now I think. At least, I'm not sure
        // I need to do something else here in the first version.
    }
}
