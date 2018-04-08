macro_rules! assert_special {
    ($left:expr, $right:expr) => ({
        match (&$left, &$right) {
            (left_val, right_val) => {
                if !(*left_val == *right_val) {
                    panic!("assertion_failed: `(left == right)`\
                            (left: `{:?}` right: `{:?}`)",
                    left_val, right_val)
                }

                true
            }
        }
    });
}

macro_rules! vector {
    ($elem:expr, $n:expr) => {
        ::std::vec::from_elem($elem, $n)
    };
    ($($x:expr),*) => {
        <[_]>::into_vec(Box::new([ $( $x ), *]))
    };
    // adds support for trailing comma
    ($($x:expr),+ ,) => {
        // delegate creation to second macro case
        vector![$($x), *]
    }
}


// Pattern language of regular expressions:

// $( ... )* Match 0 or more times with no separator

// $( ... ),* Match 0 or more times, separated by commas

// $( ... );* Match 0 or more times, separated by semicolons

// $( ... )+ Match 1 or more times with no separator

// $( ... ),+ Match 1 or more times, separated by commas

// $( ... );+ Match 1 or more times, separated by semicolons


fn main() {
    let val = assert_special!("hello", "hello");
    println!("{:?}", val);

    let some_vector = vector![10, 1];
    println!("{:?}", some_vector);

    // third case with trailing comma
    let some_vector_with_trailing_comma = vector![10, 1, 10,];
    println!("{:?}", some_vector_with_trailing_comma);
}
