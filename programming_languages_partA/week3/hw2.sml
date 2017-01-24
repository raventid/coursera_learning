(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* (a) *)
fun all_except_option(s : string, ls : string list) =
  let
    fun filter(xs : string list) = 
      case xs of
        [] => [] 
        | x::xs' => if same_string(s, x) 
                    then filter xs' 
                    else x::filter xs'

    val filtered_list = filter ls
  in
    if filtered_list=ls then NONE else SOME filtered_list
  end

(* (b) *)
fun get_substitutions1(ls : string list list, s : string) =
  case ls of
    [] => []
  | l::ls' => case all_except_option(s, l) of 
                SOME xs' => xs' @ get_substitutions1(ls', s) 
              | NONE   => get_substitutions1(ls', s) 

(* (c) Write a function get_substitutions2, which is like get_substitutions1 except it uses a tail-recursive
local helper function. *)
fun get_substitutions2(ls : string list list, s : string) =
      let fun accumulate(acc : string list, xs : string list list) =
        case xs of
          [] => []
        | x::xs' => case all_except_option(s, x) of
                    SOME ys' => accumulate(acc @ ys', xs')
                    | NONE => accumulate(acc, xs') 
      in
        accumulate([], ls)
      end
           

              

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
