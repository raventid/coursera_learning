open Core

type t =
    A_OP of Address_operation.t
  | C_OP of Command_operation.t
  | Label of string

let to_string t = match t with
  | A_OP _ -> "A_OP"
  | C_OP _ -> "C_OP"
  | Label symbol_name -> Printf.sprintf "(%s)" symbol_name

let to_code t symbol_table = match t with
  | A_OP op -> Address_operation.to_code op symbol_table
  | C_OP op -> Command_operation.to_code op
  | Label _ -> failwith "can't convert label to code"

let code_to_string code =
  let rec cons_bit code n chars =
    if n = 0 then chars
    else
      let bit = if (code land 1) = 1 then '1' else '0' in
      cons_bit (code lsr 1) (n - 1) (bit :: chars) in
  let bit_length = 16 in
  let chars = cons_bit code bit_length [] in
  let buffer = List.fold chars ~init:(Buffer.create bit_length) ~f:(fun buf c ->
      (Buffer.add_char buf c; buf)) in
  Buffer.contents buffer
