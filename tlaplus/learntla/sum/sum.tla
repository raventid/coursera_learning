-------------------------------- MODULE sum --------------------------------

EXTENDS Integers, Sequences, TLC, FiniteSets
CONSTANT S
ASSUME S \subseteq Int

SumSeq(s) == 0 \* ???

(*--algorithm dup
variable 
  seq \in [1..5 -> S];
  sum = 0;
  i = 1;

define
  TypeInvariant ==
    /\ sum \in Int
    /\ i \in 1..Len(seq)+1

  IsCorrect == pc = "Done" => sum = SumSeq(seq)
end define; 

macro add(x, val) begin
  x := x + val
end macro;

begin
  Iterate:
    while i <= Len(seq) do
      add(sum, seq[i]);
      add(i, 1);
    end while;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "96f30b99" /\ chksum(tla) = "31fbec96")
VARIABLES seq, sum, i, pc

(* define statement *)
TypeInvariant ==
  /\ sum \in Int
  /\ i \in 1..Len(seq)+1

IsCorrect == pc = "Done" => sum = SumSeq(seq)


vars == << seq, sum, i, pc >>

Init == (* Global variables *)
        /\ seq \in [1..5 -> S]
        /\ sum = 0
        /\ i = 1
        /\ pc = "Iterate"

Iterate == /\ pc = "Iterate"
           /\ IF i <= Len(seq)
                 THEN /\ sum' = sum + (seq[i])
                      /\ i' = i + 1
                      /\ pc' = "Iterate"
                 ELSE /\ pc' = "Done"
                      /\ UNCHANGED << sum, i >>
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
\* Last modified Sun Aug 06 15:51:23 HKT 2023 by raventid
\* Created Sun Aug 06 15:50:59 HKT 2023 by raventid
