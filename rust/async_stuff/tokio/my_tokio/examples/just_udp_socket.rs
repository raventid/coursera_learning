// cargo run --example just_udp_socket
// echo -n "hello" > /dev/udp/0.0.0.0/5546 // this isn't working version

// this one requires socat, but works like a breeze
// echo -e "\xff" | socat - UDP-DATAGRAM:0.0.0.0:5546,broadcast

use std::net::UdpSocket;
use std::time::{Duration, Instant};
use std::io::ErrorKind;
use std::str;
use std::thread;

fn main() {
    let sock = UdpSocket::bind("0.0.0.0:5546").expect("Failed to bind socket");
    sock.set_nonblocking(true) .expect("Failed to enter non-blocking mode");

    // Poll for data every 5 milliseconds for 5 seconds.
    let start = Instant::now();
    let mut buf = [0u8; 1024];

    // for 50 seconds...
    while start.elapsed().as_secs() < 50 {
        let result = sock.recv(&mut buf);
        match result {
            // If `recv` was successfull, print the number of bytes received.
            // The received data is stored in `buf`.
            Ok(num_bytes) => {
                println!("I received {} bytes! Message is {}", num_bytes, String::from_utf8_lossy(&buf[0..num_bytes]));
            }
            // If we get an error other than "would block", print the error.
            Err(ref err) if err.kind() != ErrorKind::WouldBlock => {
            // Do nothing otherwise.
                println!("Something went wrong: {}", err)
            }
            _ => {}
        }

        thread::sleep(Duration::from_millis(5));
    }

    println!("Done");
}
