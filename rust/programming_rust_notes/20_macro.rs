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


fn main() {
    let val = assert_special!("hello", "hello");
    println!("{:?}", val);
}
