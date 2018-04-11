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

// Json macro:
macro_rules! json {
    (null) => {
        Json::Null
    };
    // expr does not work here, because in json! macro we need not Rust code, but very specific stuff
    // tt - token tree is very good for this, it matches either
    // a properly matched pair of brackets, (...) [...] or {...}, and everything in between,
    // including nested token trees;
    // or a single token that isn’t a bracket, like 1926 or "Knots".
    ([ $( $element:tt ), * ]) => {
        // let's convert some JSON stuff to Rust (will call our json! recursivly)
        Json::Array(vec![ $( json!($element)), * ])
    };
    // ({ $( $key:tt : $value:tt ), * }) => {
    //     // don't forget to wrap ($key.to_string(), json!($value)) in parenthesis.
    //     Json::Object(Box::new(vec![$( ($key.to_string(), json!($value)) ), *].into_iter().collect()))
    // };

    // object macro with local variable instead of into_iter()
    ({ $( $key:tt : $value:tt ), * }) => {
        // wrap this code in scope
        {
            let mut fields = Box::new(HashMap::new());
            $( fields.insert($key.to_string(), json!($value)); )*
                Json::Object(fields)
        }
    };

    ($other:tt) => {
        Json::from($other)
    };
}

impl From<bool> for Json {
    fn from(b: bool) -> Json {
        Json::Boolean(b)
    }
}

impl From<String> for Json {
    fn from(s: String) -> Json {
        Json::String(s)
    }
}

impl<'a> From<&'a str> for Json {
    fn from(s: &'a str) -> Json {
        Json::String(s.to_string())
    }
}

macro_rules! impl_json_for {
    ( $( $t:ident ), * ) => {
        $(
            impl From<$t> for Json {
                fn from(number: $t) -> Json {
                    Json::Number(number as f64)
                }
            }
        )*
    }
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

    println!("{:?}", students);

    // Test for json macro:
    assert_eq!(json!(null), Json::Null);

    impl_json_for!(u8, i8, u16, u32, i32, u64, i64, usize, isize, f32, f64);

    let _one_more_test = json!({
        "width": 10
        // "height": (10 * 2)
    });

    // let's delegate this code generation to macro
    let students_with_macro = json!([{
        "name": "Raventid",
        "age": 32
    },
    {
        "name": "Raventida",
        "age": 26
    }]);

    println!("{:?}", students_with_macro);
}
