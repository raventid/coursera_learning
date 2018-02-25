enum MyOption<T> {
  None,
  Some(T)
}

enum MyResult<T, E> {
  Ok(T),
  Err(E)
}

enum BinaryTree<T> {
  Empty,
  NonEmpty(Box<(T, BinaryTree<T>, BinaryTree<T>)>)
}

// We have to import internal structures, cause Rust carefully hides internal structures from us.
use self::BinaryTree::*;

impl<T: Ord> BinaryTree<T> {
  fn add(&mut self, value: T) {
    match *self {
      Empty =>
        *self = NonEmpty(Box::new((value, Empty, Empty))),
      NonEmpty(ref mut node) =>
        if value <= node.0 {
          node.1.add(value);
        } else {
          node.2.add(value);
        }
    }
  }
}
