// This is a standard function-pack
// strongly recommend to include it everywhere
// to avoid very long-time debug sessions.

#include "share/atspre_staload.hats"


val _ = println! ("(1+2)/(3+4) = ", (1+2)/(3+4))

val _ = println! ("-1 = ", x) where {
    val x = ~1
}

val _ = (
    println! ("0.123 = ", 0.123);
    println! ("0.000314 = ", 314E-6);
)

val _ = (
  println! ("float is ", x, " and double is ", y);
) where {
  val x = 2.0f; // float
  val y = 2.0; // double
}

val+ 3 = op+(1,2)

implement main0 () = ()