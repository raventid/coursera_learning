--------------------------- MODULE reader_writer ---------------------------

EXTENDS Integers, Sequences, TLC

(* --algorithm reader_writer
variables
  queue = <<>>;
  total = 0;
  i = 0;
  WriterSet = {1,2,3};


process writer \in WriterSet
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
\* BEGIN TRANSLATION (chksum(pcal) = "a0aaccf6" /\ chksum(tla) = "f0cf6b8b")
VARIABLES queue, total, i, WriterSet, pc

vars == << queue, total, i, WriterSet, pc >>

ProcSet == (WriterSet) \cup {0}

Init == (* Global variables *)
        /\ queue = <<>>
        /\ total = 0
        /\ i = 0
        /\ WriterSet = {1,2,3}
        /\ pc = [self \in ProcSet |-> CASE self \in WriterSet -> "AddToQueue"
                                        [] self = 0 -> "ReadFromQueue"]

AddToQueue(self) == /\ pc[self] = "AddToQueue"
                    /\ queue' = Append(queue, 1)
                    /\ pc' = [pc EXCEPT ![self] = "Done"]
                    /\ UNCHANGED << total, i, WriterSet >>

writer(self) == AddToQueue(self)

ReadFromQueue == /\ pc[0] = "ReadFromQueue"
                 /\ IF queue # <<>>
                       THEN /\ total' = total + Head(queue)
                            /\ queue' = Tail(queue)
                       ELSE /\ TRUE
                            /\ UNCHANGED << queue, total >>
                 /\ pc' = [pc EXCEPT ![0] = "Done"]
                 /\ UNCHANGED << i, WriterSet >>

reader == ReadFromQueue

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == reader
           \/ (\E self \in WriterSet: writer(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Jul 16 23:59:46 HKT 2023 by raventid
\* Created Sun Jul 16 23:13:11 HKT 2023 by raventid
