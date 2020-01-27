// patscc -o s scratch.dats && ./s

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

fun test_in_operator (dataset: (int, int, int), i: int): (int, int, int) = let
  val (x0, x1, x2) = dataset
in
  let val x0 = i in (x0, x1, x2) end
end

implement main0 () = let
  val v = (1, 2, 3)
in
  print(v)
end