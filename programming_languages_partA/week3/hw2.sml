(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
string), then you avoid several of the functions in problem 1 having
polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
  s1 = s2

(* put your solutions for problem 1 here *)

(* a *)
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

(* b *)
fun get_substitutions1(ls : string list list, s : string) =
  case ls of
    [] => []
  | l::ls' => case all_except_option(s, l) of 
                SOME xs' => xs' @ get_substitutions1(ls', s) 
              | NONE   => get_substitutions1(ls', s) 

(* c *)
fun get_substitutions2(ls : string list list, s : string) =
  let fun accumulate(acc : string list, xs : string list list) =
  case xs of
    [] => acc 
  | x::xs' => case all_except_option(s, x) of
                SOME ys' => accumulate(acc @ ys', xs')
              | NONE => accumulate(acc, xs') 
  in
    accumulate([], ls)
  end

(* d *)
(* If I use an accumulator here I get a wrong order. How to deal with it and do it with TCO? *)
fun similar_names(xs : string list list, {first, middle, last}) =
  let
    fun combinate(xs : string list) =
      case xs of 
        [] => [] 
      | x::xs' => {first=x, middle=middle, last=last}::combinate(xs') 
  in
    combinate(first :: get_substitutions2(xs, first))
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

(* a *)
fun card_color(card : card) =
  case card of
    (Spades, _) => Black
  | (Clubs, _) => Black
  | _ => Red

(* b *)
fun card_value(card : card) =
  case card of
    (_, Num i) => i
  | (_, Ace) => 11
  | _ => 10 

(* c *)
fun remove_card(cs, c, e) =
  case cs of
    [] => raise e
  | x::xs => if x = c
             then xs
             else x::remove_card(xs, c, e) 

(* d *)
fun all_same_color(cs) =
  case cs of
    [] => true
  | x::[] => true
  | x::y::ys => if card_color x = card_color y
                then all_same_color (y::ys)
                else false

(* e *)
fun sum_cards(cs) =
  let fun sum (cs, acc) = 
    case cs of
      [] => acc
    | x::xs => sum(xs, acc + card_value x)
  in 
    sum(cs, 0)
  end

(* f *)
fun score(cs, goal) =
  let val sum = sum_cards cs
    val pre_score = if sum > goal
                    then 3 * (sum - goal)
                    else goal - sum
  in
    pre_score div (if all_same_color(cs) then 2 else 1)
  end

(* g *)
fun officiate(cards, moves, goal) =
  let fun run_game (cards, held, moves_left) = 
    case moves_left of
      [] => score(held, goal)
    | (Discard c)::ms => run_game(cards, remove_card(held, c, IllegalMove), ms)
    | (Draw)::ms => case cards of 
                      [] => score(held, goal)
                    | c::cs => if (sum_cards held) + (card_value c) > goal
                               then score(c::held, goal)
                               else run_game(cs, c::held, ms)
  in
    run_game(cards, [], moves)
  end
