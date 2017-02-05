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

val alias = triple_n_times_a

fun map(f, xs) = 
  case xs of
    [] => []
  | x::xs' => (f x)::map(f, xs')

val mapped_val = map(hd, [[1,2,3],[4,5,6],[7,8,9]])

fun filter(f, xs) = 
  case xs of
    [] => []
  | x::xs' => if f x then x::filter(f, xs') else filter(f, xs')

fun is_even(number : int) = 
  (number mod 2)=0

fun all_even_snd xs =
  filter((fn (_, v) => is_even v), xs)

fun f g =
  let 
    val x = 3 (* irrelevant *)
  in
    g 2
  end

val x = 4
fun h y = x + y (* adds 4 to its argument *)
val z = f h (* 6 *)
