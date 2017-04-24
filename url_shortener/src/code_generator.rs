extern crate rand;

use rand::Rng;

fn generate_random_key(length: i16) -> String {
    rand::thread_rng()
        .gen_ascii_chars()
        .take(length)
        .collect();
}
