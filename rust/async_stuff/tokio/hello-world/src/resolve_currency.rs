pub fn resolve(host: &str) -> ResolveFuture;

enum State {
    Resolving(ResolveFuture), // currently resolving the host name
    Connecting(ConnectFuture), // establishing a TCP connection to the remote host
}

pub struct ResolveAndConnect {
    state: State,
}

pub fn resolve_and_connect(host: &str) -> ResolveAndConnect {
    let state = State::Resolving(resolve(host));
    ResolveAndConnect { state }
}

impl Future for ResolveAndConnect {
    type Item = TcpStream;
    type Error = io::Error;

    fn poll(&mut self) -> Result<Async<TcpStream>, io::Error> {
        use self::State::*;

        loop {
            let addr = match self.state {
                Resolving(ref mut fut) => {
                    try_ready!(fut.poll())
                }
                Connecting(ref mut fut) => {
                    return fut.poll()
                }
            }

            // if we reach here, the state was `Resolving`
            // and the call to the inner Future return ed `Ready`
            // it happens because `try_ready!` does not leave the method.
            let connecting = TcpStream::connect(&addr);
            self.state = Connecting(connecting)
        }
    }
}

// This is not very smart in fact, that looks
// just like reimplementation of and_then combinator.

resolve(my_host).and_then(|addr| TcpStream::connect(&addr))
