------------------------------ MODULE recycler ------------------------------
EXTENDS Sequences, Integers, TLC

(*--algorithm recycler
variables
  \* capacity = [trash |-> 10, recycle |-> 10],
  capacity \in [trash: 1..10, recycle: 1..10],
  bins = [trash |-> <<>>, recycle |-> <<>>],
  count = [trash |-> 0, recycle |-> 0],
  item = [type: {"trash", "recycle"}, size: 1..6],
  items \in item \X item \X item \X item,
  \* items = <<
  \*  [type |-> "recycle", size |-> 5],
  \*  [type |-> "trash", size |-> 5],
  \*  [type |-> "recycle", size |-> 4],
  \*  [type |-> "recycle", size |-> 3]
  \* >>,
  curr = ""; \* helper: current item
  
  \* Обращаться к полю можно, как с помощью dot notation, так и через []
  \* Конечно PlusCal не самый удобный язык, но хоть чуток менее вербозный, чем голый TLA+
  macro add_item(type) begin
    bins[type] := Append(bins[type], curr);
    capacity[type] := capacity[type] - curr.size;
    count[type] := count[type] + 1;
  end macro;
  
  begin
   while items /= <<>> do
     curr := Head(items);
     items := Tail(items);
     if curr.type = "recycle" /\ curr.size < capacity.recycle then
       \* bins.recycle := bins.recycle \union {curr};
       \* capacity.recycle := capacity.recycle - curr.size;
       \* count.recycle := count.recycle + 1;
       add_item("recycle");
     elsif curr.size < capacity.trash then
       add_item("trash");
     end if;
   end while;
   
   assert capacity.trash >= 0 /\ capacity.recycle >= 0;
   assert Len(bins.trash) = count.trash;
   assert Len(bins.recycle) = count.recycle;
end algorithm; *)
\* BEGIN TRANSLATION
VARIABLES capacity, bins, count, item, items, curr, pc

vars == << capacity, bins, count, item, items, curr, pc >>

Init == (* Global variables *)
        /\ capacity \in [trash: 1..10, recycle: 1..10]
        /\ bins = [trash |-> <<>>, recycle |-> <<>>]
        /\ count = [trash |-> 0, recycle |-> 0]
        /\ item = [type: {"trash", "recycle"}, size: 1..6]
        /\ items \in item \X item \X item \X item
        /\ curr = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF items /= <<>>
               THEN /\ curr' = Head(items)
                    /\ items' = Tail(items)
                    /\ IF curr'.type = "recycle" /\ curr'.size < capacity.recycle
                          THEN /\ bins' = [bins EXCEPT !["recycle"] = Append(bins["recycle"], curr')]
                               /\ capacity' = [capacity EXCEPT !["recycle"] = capacity["recycle"] - curr'.size]
                               /\ count' = [count EXCEPT !["recycle"] = count["recycle"] + 1]
                          ELSE /\ IF curr'.size < capacity.trash
                                     THEN /\ bins' = [bins EXCEPT !["trash"] = Append(bins["trash"], curr')]
                                          /\ capacity' = [capacity EXCEPT !["trash"] = capacity["trash"] - curr'.size]
                                          /\ count' = [count EXCEPT !["trash"] = count["trash"] + 1]
                                     ELSE /\ TRUE
                                          /\ UNCHANGED << capacity, bins, 
                                                          count >>
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(capacity.trash >= 0 /\ capacity.recycle >= 0, 
                              "Failure of assertion at line 42, column 4.")
                    /\ Assert(Len(bins.trash) = count.trash, 
                              "Failure of assertion at line 43, column 4.")
                    /\ Assert(Len(bins.recycle) = count.recycle, 
                              "Failure of assertion at line 44, column 4.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << capacity, bins, count, items, curr >>
         /\ item' = item

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION
=============================================================================
\* Modification History
\* Last modified Fri Feb 21 23:42:23 MSK 2020 by juliankulesh
\* Created Wed Feb 12 01:58:37 MSK 2020 by juliankulesh
