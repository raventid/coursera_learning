use std::time::{SystemTime, UNIX_EPOCH};

const WINDOW_SIZE_MILLIS: u128 = 1000;
const REQUEST_PER_WINDOW: u128 = 50;

struct RpsTracker {
    log: std::collections::VecDeque<u128>,
}

impl RpsTracker {
   fn new() -> Self {
         RpsTracker {
            log: std::collections::VecDeque::new()
        }
    }

    fn can_send(&mut self) -> bool {
        let current_timestamp_millis = Self::get_timestamp_in_milliseconds();
        let oldest_boundary = current_timestamp_millis - WINDOW_SIZE_MILLIS;

        while let Some(timestamp) = self.log.front() {
            if *timestamp <= oldest_boundary {
                self.log.pop_front();
            } else {
                break;
            }
        }

        self.log.push_back(current_timestamp_millis);

        self.log.len() <= REQUEST_PER_WINDOW as usize
    }

    fn send(&mut self, i:u64) {
        if self.can_send() {
            println!("sending {}", i);
        }
    }

    fn get_timestamp_in_milliseconds() -> u128 {
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("Time went backwards")
            .as_millis()
    }
}

fn main() {
    let mut tracker = RpsTracker::new();

    for i in 1..1_000 {
        tracker.send(i)
    }

    std::thread::sleep(std::time::Duration::from_secs(1));

    for i in 1..1_000 {
        tracker.send(i)
    }
}
