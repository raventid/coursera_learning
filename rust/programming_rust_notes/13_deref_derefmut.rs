struct Selector<T> {
    elements: Vec<T>,
    current: usize
}

use std::ops::{Deref, DerefMut};

impl<T> Deref for Selector<T> {
    type Target = T;
    fn deref(&self) -> &T {
        &self.elements[self.current]
    }
}

impl<T> DerefMut for Selector<T> {
    fn deref_mut(&mut self) -> &mut T {
        &mut self.elements[self.current]
    }
}

// A string literal is a &str, but the type that implements AsRef<Path> is str,
// without an &. And as we explained in “Deref and DerefMut” on page 289,
// Rust doesn’t try deref coercions to satisfy type variable bounds,
// so they won’t help here either.

// Fortunately, the standard library includes the blanket implementation:

// impl<'a, T, U> AsRef<U> for &'a T
//   where T: AsRef<U>, T: ?Sized, U: ?Sized
// {
//     fn as_ref(&self) -> &U {
//         (*self).as_ref()
//     }
// }

// In other words, for any types T and U, if T: AsRef<U>, then &T: AsRef<U> as well:
// simply follow the reference and proceed as before.
// In particular, since str: AsRef<Path>, then &str: AsRef<Path> as well.
// In a sense, this is a way to get a limited form of deref coercion
// in checking AsRef bounds on type variables.

fn main() {
    let mut s = Selector { elements: vec!['x', 'y', 'z'],
                           current: 2 };


    assert_eq!(*s, 'z');
}

