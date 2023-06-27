----------------------------- MODULE duplicator -----------------------------
EXTENDS Integers, Sequences, TLC, FiniteSets
S == 1..10


(*--algorithm dup
variable
  seq \in S \X S;
  index = 1;
  seen = {};
  is_unique = TRUE;
    
define
  TypeInvariant ==
    /\ is_unique \in BOOLEAN
    /\ seen \subseteq S
    /\ index \in 1..Len(seq)+1
    
  IsUnique(s) == \A i, j \in 1..Len(s):
    seq[i] # seq[j]
    
  IsCorrect == IF pc = "Done" THEN is_unique = IsUnique(seq) ELSE TRUE
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


\* BEGIN TRANSLATION (chksum(pcal) = "28c4316a" /\ chksum(tla) = "a8c9a467")
VARIABLES seq, index, seen, is_unique, pc

(* define statement *)
TypeInvariant ==
  /\ is_unique \in BOOLEAN
  /\ seen \subseteq S
  /\ index \in 1..Len(seq)+1

IsUnique(s) == \A i, j \in 1..Len(s):
  seq[i] # seq[j]

IsCorrect == IF pc = "Done" THEN is_unique = IsUnique(seq) ELSE TRUE


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
\* Last modified Mon Jun 26 02:33:18 HKT 2023 by raventid
\* Created Sun Jun 25 19:37:55 HKT 2023 by raventid
