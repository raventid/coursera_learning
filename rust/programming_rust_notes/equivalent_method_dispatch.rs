fn main() {
    "hello".to_string(); // implicit dispatch

    // Group of `qualified` methods:
    str::to_string("hello"); // explicit dispatch by struct
    ToString::to_string("hello"); // explicit dispatch by trait

    // `Fully qualified` method call ()
    <str as ToString>::to_string("hello"); // wow!
}
