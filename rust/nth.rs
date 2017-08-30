let mut squares = (0..10).map(|i| i*i);

// What if we have ?Sized
// We need to strictly separate mutable and immutable iterators
assert_eq!(squares.nth(4), Some(16));
assert_eq!(squares.nth(0), Some(25));
assert_eq!(squares.nth(6), None);
