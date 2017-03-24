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
