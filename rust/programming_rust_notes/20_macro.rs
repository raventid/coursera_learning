use std::collections::HashMap;


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


#[derive(Clone, PartialEq, Debug)]
enum Json {
    Null,
    Boolean(bool),
    Number(f64),
    String(String),
    Array(Vec<Json>),
    Object(Box<HashMap<String, Json>>)
}


fn main() {
    let val = assert_special!("hello", "hello");
    println!("{:?}", val);

    let some_vector = vector![10, 1];
    println!("{:?}", some_vector);

    // third case with trailing comma
    let some_vector_with_trailing_comma = vector![10, 1, 10,];
    println!("{:?}", some_vector_with_trailing_comma);

    // initialize Json structure without a macro
    let students = Json::Array(vec![
        Json::Object(Box::new(vec![
            ("name".to_string(), Json::String("Raventid".to_string())),
            ("age".to_string(), Json::Number(32.))
        ].into_iter().collect())),
        Json::Object(Box::new(vec![
            ("name".to_string(), Json::String("Raventida".to_string())),
            ("age".to_string(), Json::Number(26.))
        ].into_iter().collect()))
    ]);

    // let's delegate this code generation to macro
    let students = json!([{
        "name": "Raventid",
        "class_of": 32
    },
    {
        "name": "Raventida",
        "age": 26
    }]);

    println!("{:?}", students);
}
