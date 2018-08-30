// error[E0277]: the size for values of type `(dyn Vegetable + 'static)` cannot be known at compilation time
//     --> /Users/juliankulesh/Experiments/coursera_learning/rust/programming_rust_notes/dynamic_traits.rs:4:5
//     |
//   4 |     veggies: Vec<Vegetable> // error: `Vegetable` does not have
//     |     ^^^^^^^^^^^^^^^^^^^^^^^ doesn't have a size known at compile-time
//     |
// = help: the trait `std::marker::Sized` is not implemented for `(dyn Vegetable + 'static)`
// = note: to learn more, visit <https://doc.rust-lang.org/book/second-edition/ch19-04-advanced-types.html#dynamically-sized-types-and-the-sized-trait>
// = note: required by `std::vec::Vec`
trait Vegetable {}

struct Salad {
    veggies: Vec<Vegetable>
}

fn main() {}
