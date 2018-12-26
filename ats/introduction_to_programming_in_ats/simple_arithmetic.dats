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


implement main0 () = ()