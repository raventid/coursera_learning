--------------------- MODULE threads_counter_increment ---------------------


EXTENDS TLC, Sequences, Integers

NumThreads == 2
Threads == 1..NumThreads

(* --algorithm threads

variables 
  counter = 0;

define
  AllDone == 
    \A t \in Threads: pc[t] = "Done"

  Correct ==
      AllDone => counter = NumThreads
end define;  

process thread \in Threads
variables tmp = 0;
begin
  GetCounter:
    tmp := counter + 1;
    
  IncCounter:
    counter := tmp + 1;
end process;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "b62a1e19" /\ chksum(tla) = "949accc7")
VARIABLES counter, pc

(* define statement *)
AllDone ==
  \A t \in Threads: pc[t] = "Done"

Correct ==
    AllDone => counter = NumThreads

VARIABLE tmp

vars == << counter, pc, tmp >>

ProcSet == (Threads)

Init == (* Global variables *)
        /\ counter = 0
        (* Process thread *)
        /\ tmp = [self \in Threads |-> 0]
        /\ pc = [self \in ProcSet |-> "GetCounter"]

GetCounter(self) == /\ pc[self] = "GetCounter"
                    /\ tmp' = [tmp EXCEPT ![self] = counter + 1]
                    /\ pc' = [pc EXCEPT ![self] = "IncCounter"]
                    /\ UNCHANGED counter

IncCounter(self) == /\ pc[self] = "IncCounter"
                    /\ counter' = tmp[self] + 1
                    /\ pc' = [pc EXCEPT ![self] = "Done"]
                    /\ tmp' = tmp

thread(self) == GetCounter(self) \/ IncCounter(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Threads: thread(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Jul 30 22:05:05 HKT 2023 by raventid
\* Created Sun Jul 30 21:57:54 HKT 2023 by raventid
