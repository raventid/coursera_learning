(* Coursera Programming Languages, Homework 3, Provided Code *) 
exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* 1 *)
fun only_capitals(xs : string list) = 
  List.filter (fn x => Char.isUpper(String.sub(x, 0))) xs

(* 2 *)
fun longest_string1(xs : string list) =
  List.foldl (fn(x, y) => if String.size(x) > String.size(y) then x else y) "" xs

(* 3 *)
fun longest_string2(xs : string list) = 
  List.foldl (fn(x,y) => if String.size(x) >= String.size(y) then x else y) "" xs 

(* 4 *)
fun longest_string_helper f xs = 
  List.foldl (fn(x,y) => if f(String.size(x), String.size(y)) then x else y) "" xs

val longest_string3 = longest_string_helper (fn (x, y) => x > y)
val longest_string4 = longest_string_helper (fn (x, y) => x >= y)

(* 5 *)
val longest_capitalized = longest_string1 o only_capitals

(* 6 *)
val rev_string = String.implode o rev o String.explode

(* 7 *)
fun first_answer f xs =
  case List.filter (fn x => case x of SOME _ => true | NONE => false) (List.map f xs) of
       (SOME x)::_ => x
     | [] => raise NoAnswer

(* 8 *)
fun all_answers f xs =
  let fun foldit(x, acc) =
  case acc of
    NONE => NONE
  | SOME xs => case x of
                 SOME i => SOME (xs @ i)
               | NONE => NONE
  in 
    List.foldl foldit (SOME []) (List.map f xs)
  end

(* 9 *)
fun count_wildcards p = g (fn _ => 1) (fn _ => 0) p
fun count_wild_and_variable_lengths p = g (fn _ => 1) (fn x => String.size x) p
fun count_some_var (s, p) = g (fn _ => 0) (fn x => if x = s then 1 else 0) p


(* 10 *)
fun check_pat p = 
  let fun get_vars p = 
  case p of
    Variable x  => [x]
  | TupleP ps => List.foldl (fn (x,acc) => x @ acc) [] (List.map get_vars ps)
  | _         => []
    fun check xs =
      case xs of
        []       => true
      | x::xs' => if not (List.exists (fn y => y = x) xs')
                  then check(xs')
                  else false
  in 
    check (get_vars p)
  end

(* 11 *)
fun match (v, p) =
  case (v, p) of
    (_, Wildcard)    => SOME []
  | (_, Variable(s)) => SOME [(s, v)]
  | (Unit, UnitP)    => SOME []
  | (Const i, ConstP j)    => if i=j then SOME [] else NONE
  | (Tuple(vs), TupleP(ps)) => if length vs = length ps
                               then all_answers match (ListPair.zip(vs,ps))
                               else NONE
  | (Constructor(s1, v), ConstructorP(s2, p)) => if s1=s2
                                                 then match(v,p)
                                                 else NONE
  | _ => NONE


(* 12 *)
fun first_match v ps =
  SOME (first_answer (fn p => match (v, p)) ps) handle NoAnswer => NONE
