let id = "Iterator";

// This is straightforward, because we need to find just first occurence of true predicate calculation
assert!(id.chars().any(char::is_uppercase));

// Do we need to iterate through hall collection? Or Rust compiler can optimize this case? If not, it should.
assert!(!id.chars().any(char::is_uppercase));
