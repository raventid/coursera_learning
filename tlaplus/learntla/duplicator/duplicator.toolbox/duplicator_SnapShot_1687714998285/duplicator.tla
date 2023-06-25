----------------------------- MODULE duplicator -----------------------------
EXTENDS Integers, Sequences, TLC
S == 1..10


(*--algorithm dup
variable
  seq \in S \X S;
  index = 1;
  seen = {};
  is_unique = TRUE;
  
define
  TypeInvariant ==
    /\ is_unique = TRUE
    /\ seen \subseteq S
    /\ index \in 1..Len(seq)+1
end define;

begin
  Iterate:
    while index <= Len(seq) do
      if seq[index] \notin seen then
        seen := seen \union {seq[index]};
      else
        is_unique := FALSE;
      end if;
      index := index + 1;
    end while;
end algorithm; *)


\* BEGIN TRANSLATION (chksum(pcal) = "bdd76c1d" /\ chksum(tla) = "193dc34e")
VARIABLES seq, index, seen, is_unique, pc

(* define statement *)
TypeInvariant ==
  /\ is_unique = TRUE
  /\ seen \subseteq S
  /\ index \in 1..Len(seq)+1


vars == << seq, index, seen, is_unique, pc >>

Init == (* Global variables *)
        /\ seq \in S \X S
        /\ index = 1
        /\ seen = {}
        /\ is_unique = TRUE
        /\ pc = "Iterate"

Iterate == /\ pc = "Iterate"
           /\ IF index <= Len(seq)
                 THEN /\ IF seq[index] \notin seen
                            THEN /\ seen' = (seen \union {seq[index]})
                                 /\ UNCHANGED is_unique
                            ELSE /\ is_unique' = FALSE
                                 /\ seen' = seen
                      /\ index' = index + 1
                      /\ pc' = "Iterate"
                 ELSE /\ pc' = "Done"
                      /\ UNCHANGED << index, seen, is_unique >>
           /\ seq' = seq

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Iterate
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Jun 26 01:43:06 HKT 2023 by raventid
\* Created Sun Jun 25 19:37:55 HKT 2023 by raventid
