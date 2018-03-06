// Why is this trait called PartialEq?

// The traditional mathematical definition of an equivalence relation, of which equality is one instance, imposes three requirements.

// For any values x and y:
// • If x == y is true, then y == x must be true as well.
//   In other words, swapping the two sides of an equality comparison doesn’t affect the result.
//
// • If x == y and y == z, then it must be the case that x == z.
//   Given any chain of values, each equal to the next, each value in the chain is directly equal to every other.
//   Equality is contagious.
//
// • It must always be true that x == x.

// That last requirement might seem too obvious to be worth stating, but this is exactly where things go awry.
// Rust’s f32 and f64 are IEEE standard floating-point values.
// According to that standard, expressions like 0.0/0.0 and others with no appropriate value must produce special not-a-number values, usually referred to as NaN values.
// The standard further requires that a NaN value be treated as unequal to every other value — including itself.

// Eq is full equlality constraint.
// PartialEq is Eq, but without x == x guarantee. (Wow, spirit of Haskell I feel).
