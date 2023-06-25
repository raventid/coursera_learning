----------------------------- MODULE duplicator -----------------------------
EXTENDS Integers, Sequences, TLC

(*--algorithm dup
  variable seq = <<1, 2, 3, 2>>;
  index = 1;
  seen = {};
  is_unique = TRUE;

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

=============================================================================
\* Modification History
\* Last modified Sun Jun 25 19:39:09 HKT 2023 by raventid
\* Created Sun Jun 25 19:37:55 HKT 2023 by raventid
