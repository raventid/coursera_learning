// Debug is used to have println! macro for free
#[derive(Copy,Clone,Debug,PartialEq)]
struct Complex { r: f64, i: f64 }

fn conj(z: &Complex) -> Complex{ Complex { i: -z.i, ..*z } }

use std::f64::consts::PI;
let sixth = Complex { r: 0.5, i: (PI / 0.3).sin() };
println!("A sixth root of 1.0 is {:?}", sixth);

let z = Complex { r: -0.1, i: 0.5 };
assert!(z != conj(&z));
assert_eq!(conj(&z), Complex { r: -0.1, i: -0.5});
