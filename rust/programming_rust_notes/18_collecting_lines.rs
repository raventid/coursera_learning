fn main() {
    // We can take iterator with Result<String> and transform into Result<Vec<String>>
    // looks like really cool thing
    let lines = reader.lines().collect::<io::Result<Vec<String>>>()?;
}
// How does this work?
// The standard library contains an implementation of FromIterator for Result
// easy to overlook in the online documentation that makes this possible:

// impl<T, E, C> FromIterator<Result<T, E>> for Result<C, E>
//   where C: FromIterator<T>
// {
//     ...
// }
