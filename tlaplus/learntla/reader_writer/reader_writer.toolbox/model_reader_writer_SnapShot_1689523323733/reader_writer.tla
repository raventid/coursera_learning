--------------------------- MODULE reader_writer ---------------------------

EXTENDS Integers, Sequences, TLC

(* --algorithm reader_writer
variables
  queue = <<>>;
  total = 0;
  i = 0;
  Writers = {1,2,3};


process writer \in Writers
begin
  AddToQueue:
\*    while i < 2 do
\*      queue := Append(queue, 1);
\*      i := i + 1;
\*    end while;
    queue := Append(queue, 1);
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
\* BEGIN TRANSLATION (chksum(pcal) = "95c925d6" /\ chksum(tla) = "f48bec0d")
VARIABLES queue, total, i, Writers, pc

vars == << queue, total, i, Writers, pc >>

ProcSet == (Writers) \cup {0}

Init == (* Global variables *)
        /\ queue = <<>>
        /\ total = 0
        /\ i = 0
        /\ Writers = {1,2,3}
        /\ pc = [self \in ProcSet |-> CASE self \in Writers -> "AddToQueue"
                                        [] self = 0 -> "ReadFromQueue"]

AddToQueue(self) == /\ pc[self] = "AddToQueue"
                    /\ queue' = Append(queue, 1)
                    /\ pc' = [pc EXCEPT ![self] = "Done"]
                    /\ UNCHANGED << total, i, Writers >>

writer(self) == AddToQueue(self)

ReadFromQueue == /\ pc[0] = "ReadFromQueue"
                 /\ IF queue # <<>>
                       THEN /\ total' = total + Head(queue)
                            /\ queue' = Tail(queue)
                       ELSE /\ TRUE
                            /\ UNCHANGED << queue, total >>
                 /\ pc' = [pc EXCEPT ![0] = "Done"]
                 /\ UNCHANGED << i, Writers >>

reader == ReadFromQueue

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == reader
           \/ (\E self \in Writers: writer(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Jul 17 00:01:52 HKT 2023 by raventid
\* Created Sun Jul 16 23:13:11 HKT 2023 by raventid
