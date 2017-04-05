extern crate rand;

use rand::Rng;

fn main() {
    let mut rng = rand::thread_rng();
    let letter: char = rng.gen_range(b'A', b'Z') as char;
    let number: u32 = rng.gen_range(0, 999999);
    let s = format!("{}{:06}", letter, number);
    println!("{}", s);
}
