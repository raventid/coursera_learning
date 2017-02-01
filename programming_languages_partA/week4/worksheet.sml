fun double x = x * 2
fun incr x = x + 1
val a_tuple = (double, incr, double(incr 7))

val eighteen = (#1 a_tuple) 9

fun n_times(f,n,x) =
  if n=0
  then x
  else f (n_times(f,n-1,x))

val doubling = n_times(double, 10, 5)

(* This tl function is polymorphic *)
val polymorphic_return = n_times(tl, 2, [1,2,3,4,5,6]) (* int list *)

(* Anonymous functions *)
fun triple_n_times(n,x) =
  n_times(let fun triple x = 3*x in triple end, n, x)

fun triple_n_times_a(n,x) =
  n_times((fn x => x*3), n, x)
