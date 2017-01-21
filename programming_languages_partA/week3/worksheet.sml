val x = { bar=(1+5, true andalso true), foo=2+4, baz=(false,9) }

val typed = { bar = "hello" : string }

(* Variable binding - val *)
(* Function binding - fun *)
(* Datatype binding - datatype *)


datatype myType = TwoInts of int * int
                  | Str of string
                  | Pizza


datatype suit = Club | Diamond | Heart | Spade
datatype rank = Jack | Queen | King | Ace | Num of int


type card = suit * rank

(* datatype id = StudentNum of int *)
(*               | Name of string *)
(*                * (string options) *)
(*                * string *)



datatype exp = Constant of int
             | Negate of exp
             | Add of exp * exp
             | Multiply of exp * exp
             


fun eval e =
  case e of
    Constant i => i
    | Negate e2  => ~ (eval e2)
    | Add(e1,e2) => (eval e1) + (eval e2)
    | Multiply(e1,e2) => (eval e1) * (eval e2)

datatype myList = Empty
                  | Cons of int * myList

val x = Cons(1, Cons(2, Cons(3, Cons(4, Empty))))
val y = Cons(5, Cons(6, Empty))

fun my_append(xs, ys) =
  case xs of
    Empty => ys
    | Cons(x, xs') => Cons(x, my_append(xs', ys))



(* 'a is the most abstract type in SML *)
(* ''a polymophic type wich support equality *)

(* fun same_thing(x,y) = *)
(*   if x=y then "yes" else "no" *)
