(* Helper functions *)
fun append (xs : (int * int * int) list, ys : (int * int * int) list) =
    if null xs
    then ys
    else (hd xs) :: append(tl xs, ys)


(* Homework part *)
fun is_older(first : (int * int * int), second : (int * int * int)) =
  if #1 first < #1 second
  then true
  else if #2 first < #2 second
       then true
       else if #3 first < #3 second
            then true
            else false
  
fun number_in_month(dates : (int * int * int) list, month : int) =
  if null dates
  then 0
  else if #2 (hd dates) = month
       then 1 + number_in_month(tl dates, month)
       else number_in_month(tl dates, month)

fun number_in_months(dates : (int * int * int) list, months : int list) = 
  if null months
  then 0
  else number_in_month(dates, hd months) + number_in_months(dates, tl months)


fun dates_in_month(dates : (int * int * int) list, month : int) =
  if null dates
  then []
  else if #2 (hd dates) = month
       then (hd dates) :: dates_in_month(tl dates, month)
       else dates_in_month(tl dates, month)

fun dates_in_months(dates : (int * int * int) list, months : int list) =
  if null months
  then []
  else append(dates_in_month(dates, hd months),  dates_in_months(dates, tl months))

fun get_nth(xs : string list, n : int) = 
  if null xs
  then ""
  else if 1=n
       then hd xs
       else get_nth(tl xs, n-1)

fun date_to_string(date : (int * int * int)) =
  let val months = [
       "January",
       "February", 
       "March",
       "April",
       "May",
       "June",
       "July",
       "August",
       "September",
       "October",
       "November",
       "December"
   ]
  in
   get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date) 
  end

fun number_before_reaching_sum(sum : int, xs : int list) =
  if null xs
  then 0
  else let fun calculate_sum (xs : int list, threshold : int, sum : int, position : int) =
                if (sum + (hd xs)) >= threshold 
                then position 
                else calculate_sum(tl xs, threshold, (sum + hd xs), (position + 1))  
       in
        calculate_sum(xs, sum, 0, 0) 
       end

fun what_month(d : int) =
  number_before_reaching_sum(d, [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) + 1 

fun month_range(day1 : int, day2 : int) =
  if day1=day2
  then what_month(day1) :: []
  else what_month(day1) :: month_range(day1+1, day2)

fun oldest(dates : (int * int * int) list) =
  if null dates
  then NONE
  else let fun oldest_finder(dates : (int * int * int) list) =
                if null (tl dates) 
                then hd dates
                else let val tmp_oldest = oldest_finder(tl dates) 
                         val cd = hd dates
                     in
                       if is_older(tmp_oldest, cd) then tmp_oldest else cd 
                     end
       in
         SOME (oldest_finder dates)
       end
