extern crate tokio;

use tokio::io;
use tokio::net::TcpListener;
use tokio::prelude::*;

fn main() {
    let addr = "127.0.0.1:6142".parse().unwrap();
    let listener = TcpListener::bind(&addr).unwrap();

    let server = listener.incoming().for_each(|socket| {
        println!("accepted socket; addr={:?}", socket.peer_addr().unwrap());

        let connection = io::write_all(socket, "hello world\n").then(|res| {
            println!("wrote message; success={:?}", res.is_ok());
        });

        // spawn new task to process the socket
        tokio::spawn(connection);

        Ok(())
    }).map_err(|err| {
        // All tasks must have an `Error` type of `()`
        // This forces error handling and helps avoid silent failures.
        // In our example, we are only going to log the error to STDOUT.
        println!("accept error = {:?}", err)
    });

    println!("server running on localhost:6142");
    tokio::run(server);
}


// A task that polls a single widget and writes it to STDOUT
pub struct MyTask;

impl Future for MyTask {
    // The value this future will have when ready
    type Item = ();
    type Error = ();

    fn poll(&mut self) -> Result<Async<()>, ()> {
        match poll_widget() {
            Async::Ready(widget) => {
                println!("widget={:?}", widget);
                Ok(Async::Ready(()))
            }
            Async::NotReady => {
                Ok(Async::NotReady)
            }
        }
    }
}

pub struct SpinExecutor {
    // the tasks an executor is responsible for in a double queue
    tasks: VecDeque<Box<Future<Item=(), Error=()>>>,
}

impl SpinExecutor {
    pub fn spawn<T>(&mut self, task: T)
        where T: Future<Item=(), Error=()> + 'static
    {
        self.tasks.push_back(Box::new(task))
    }

    pub fn run(&mut self) {
        // Of course, this would not be very efficient.
        // The executor spins in a busy loop and tries to poll all tasks even if the task will just return NotReady again.
        while let Some(mut task) = self.tasks.pop_front() {
            match task.poll().unwrap() {
                Async::Ready(_) => {}
                Async::NotReady => {
                    self.tasks.push_back(task);
                }
            }
        }
    }
}
