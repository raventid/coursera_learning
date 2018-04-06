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
    ($($x:expr),+ ,) => {
        vector![$($x), *]
    }
}

fn main() {
    let val = assert_special!("hello", "hello");
    println!("{:?}", val);

    let some_vector = vector![10, 1];
    println!("{:?}", some_vector);
}
