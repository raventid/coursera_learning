(* Helper functions *)
fun append (xs : (int * int * int) list, ys : (int * int * int) list) =
    if null xs
    then ys
    else (hd xs) :: append(tl xs, ys)


(* Homework part *)
fun is_older(first : int * int * int, second : int * int * int) =
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
  else let val current_sum = (hd xs) + number_before_reaching_sum(hd xs) 
       in 
         if current_sum >= sum
         then current_sum - (hd xs) 
         else number_before_reaching_sum(sum, tl xs)
       end
  
