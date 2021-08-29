fn main() {
    // Implicit dispatch
    "hello".to_string();

    // Group of `qualified` methods:

    // Explicit dispatch by struct
    str::to_string("hello");

    // Explicit dispatch by Trait
    ToString::to_string("hello");

    // `Fully qualified` method call
    <str as ToString>::to_string("hello");
}
