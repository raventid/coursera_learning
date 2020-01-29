// patscc -o mut_tailrec ch3_mutually_defined_tail_calls.dats && ./mut_tailrec

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

// Simple mutually recursive function could be defined as following:
// fun
//     iseven (n: int): bool = if n > 0 then isodd(n-1) else true
// and
//     isodd (n: int): bool = if n > 0 then iseven(n-1) else false

// If we want to compile into local jumps we might use special keyword `fnx`:
// We might do this easily, because here we have tail recursion.
fnx
    iseven (n: int): bool = if n > 0 then isodd(n-1) else true
and
    isodd (n: int): bool = if n > 0 then iseven(n-1) else false

// What the ATS compiler does in this case is to combine these two functions into a single one,
// so that each mutually recursive tail-call in their bodies can be turned into a self tail-call
// in the body of the combined function, which is then ready to be compiled into a local jump.


implement main0 () = let
  val v1 = 16
  val v2 = 17
in
  print("Is "); print(v1); print(" even? -"); print(iseven(v1)); print("\n");
  print("Is "); print(v2); print(" even? -"); print(iseven(v2)); print("\n") 
end