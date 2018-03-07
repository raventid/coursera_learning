// Rust specifies the behavior of the ordered comparison operators <, >, <=, and >=
// all in terms of a single trait,
// std::cmp::PartialOrd:

trait PartialOrd<Rhs = Self>: PartialEq<Rhs>  where Rhs: ?Sized {
    fn partial_cmp(&self, other: &Rhs) -> Option<Ordering>;

    fn lt(&self, other: &Rhs) -> bool {
        //...
    }
    fn le(&self, other: &Rhs) -> bool {
        //...
    }
    fn gt(&self, other: &Rhs) -> bool {
        //...
    }
    fn ge(&self, other: &Rhs) -> bool {
        //...
    }
}

// Note that PartialOrd<Rhs> extends PartialEq<Rhs>: you can do ordered comparisons only on types that you can also compare for equality.
// The only method of PartialOrd you must implement yourself is partial_cmp.
// When partial_cmp returns Some(o), then o indicates self’s relationship to other:

enum Ordering {
    Less, // self < other
    Equal, // self == other
    Greater, // self > other
}

// But if partial_cmp returns None, that means self and other are unordered
// with respect to each other: neither is greater than the other, nor are they equal.
// Among all of Rust’s primitive types, only comparisons between floating-point values ever return None

// Stricter Ord version. Return Ordering instead of Option<Ordering>
// Much nicer to use and much more deterministic.
trait Ord: Eq + PartialOrd<Self> {
    fn cmp(&self, other: &Self) -> Ordering;
}
