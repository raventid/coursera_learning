open Core

(* List of string -> address relations *)
type t = (string * Address.t) list

let create () = []

let add t symbol_name address = List.Assoc.add t symbol_name address

(* Is there any other list implementation, with optional equal function *)
let find t symbol_name = List.Assoc.find ~equal:(=) t symbol_name

let exists t symbol_name = List.Assoc.mem t symbol_name

let defined_symbol_exists t symbol_name =
  match find t symbol_name with
  | Some address -> begin
      match address with
      | Address.Undefined -> false
      | Address.Address address -> true
    end
  | None -> false

let to_list t = t

let of_list t = t

let to_string t =
  List.to_string t ~f:(fun (symbol_name, address) ->
      Printf.sprintf "%s: %s" symbol_name (Address.to_string address))
