use std::fmt::Debug;

// Associated types are perfect for cases where each implementation has one
// specific related type: each type of Task produces a particular type of Output;
// each type of Pattern looks for a particular type of Match.
// However, as we’ll see, some relationships among types are not like this.

// Cool way to tell Rust, that some component implement some trait
fn dump<I>(iter: I)
  where I: Iterator, I::Item: Debug
{
    // ...
}

// Or, we could write, “I must be an iterator over String values”:
fn dump<I>(iter: I)
  where I: Iterator<Item=String>
{
    // ...
}

// It works with trait objects too, which is really great
fn dump(iter: &mut Iterator<Item=String>) {
    for (index, s) in iter.enumerate() {
        println!("{}: {:?}", index, s);
    }
}

pub trait Mul<RHS=Self> {
    // ...
}

fn main() {
    // ...
}
