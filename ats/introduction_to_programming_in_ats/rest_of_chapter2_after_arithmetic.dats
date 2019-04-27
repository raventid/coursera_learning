// #include "share/atspre_define.hats"
// #include "share/atspre_staload.hats"

// unboxed or flat or native tuple
val (x, y, z) = (t.0, t.1, t.2) where {
    val t = (1, 2, 3)
}

// To compile boxed tuple we need to include
// malloc flag.

// https://groups.google.com/forum/#!msg/ats-lang-users/f4CVnYQR-LU/zyXFJqG2AAAJ
// -DATS_MEMALLOC_LIBC to patscc

// Boxed tuple (pointer to flat tuple on heap).
// It should not work with this syntax, but it works :)
// should be '('A', 1, 2.0)

val xyz = '('A', 1, 2.0)

val _ = println! ("executed successfuly")

// ******************** RECORDS ********************
// A little bit about records
typedef
userRecord = @{ nickName= string, age= uint }

val raventid = @{ nickName= "raventid", age= 30 }

// To extract the field there are two different notations
// Standard dot notation
val _nickName = raventid.nickName and _age = raventid.age
// and pattern matching. (Oh, it works like in HDL or as I want in Avanguarde)
val @{ nickName= _nickName, age= _age } = raventid


implement main0() = ()