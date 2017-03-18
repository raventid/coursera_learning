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

#[derive(Copy,Clone,Debug,PartialEq,PartialOrd)]
struct IPv4(u8, u8, u8, u8);

assert!(IPv4(127,0,0,1) < IPv4(127,0,1,0));
assert!(IPv4(66,123,54,12) >= IPv4(62,124,241,12));

use std::cmp::Ordering;
fn partial_cmp(l: &IPv4, r: &IPv4) -> Option<Ordering> {
  let c = l.0.cmp(&r.0);
  if c != Ordering::Equal { return Some(c); }
  
  let c = l.1.cmp(&r.1);
  if c != Ordering::Equal { return Some(c); }

  let c = l.2.cmp(&r.2);
  if c != Ordering::Equal { return Some(c); }

  return Some(l.3.cmp(&r.3));
}

