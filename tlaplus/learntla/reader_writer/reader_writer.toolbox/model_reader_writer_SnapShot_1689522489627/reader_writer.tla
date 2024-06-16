--------------------------- MODULE reader_writer ---------------------------

EXTENDS Integers, Sequences, TLC

(* --algorithm reader_writer
variables
  queue = <<>>;
  total = 0;


process writer = 1
variables
  i = 0;
begin
  AddToQueue:
    while i < 2 do
      queue := Append(queue, 1);
      i := i + 1;
    end while;
end process;

process reader = 0
begin
  ReadFromQueue:
    if queue # <<>> then
        total := total + Head(queue);
        queue := Tail(queue);
    end if;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "3976d72d" /\ chksum(tla) = "7edfcd92")
VARIABLES queue, total, pc, i

vars == << queue, total, pc, i >>

ProcSet == {1} \cup {0}

Init == (* Global variables *)
        /\ queue = <<>>
        /\ total = 0
        (* Process writer *)
        /\ i = 0
        /\ pc = [self \in ProcSet |-> CASE self = 1 -> "AddToQueue"
                                        [] self = 0 -> "ReadFromQueue"]

AddToQueue == /\ pc[1] = "AddToQueue"
              /\ IF i < 2
                    THEN /\ queue' = Append(queue, 1)
                         /\ i' = i + 1
                         /\ pc' = [pc EXCEPT ![1] = "AddToQueue"]
                    ELSE /\ pc' = [pc EXCEPT ![1] = "Done"]
                         /\ UNCHANGED << queue, i >>
              /\ total' = total

writer == AddToQueue

ReadFromQueue == /\ pc[0] = "ReadFromQueue"
                 /\ IF queue # <<>>
                       THEN /\ total' = total + Head(queue)
                            /\ queue' = Tail(queue)
                       ELSE /\ TRUE
                            /\ UNCHANGED << queue, total >>
                 /\ pc' = [pc EXCEPT ![0] = "Done"]
                 /\ i' = i

reader == ReadFromQueue

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == writer \/ reader
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Jul 16 23:47:57 HKT 2023 by raventid
\* Created Sun Jul 16 23:13:11 HKT 2023 by raventid
