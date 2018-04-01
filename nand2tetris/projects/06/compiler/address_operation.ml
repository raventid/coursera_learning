(* It might be String or Int *)
type t =
  | Number of int
  | Symbol of string

(*
   If address is a number, let's just return it.
   If address is a symbol, let's look for this symbol in symbol table.
*)
let to_code t table =
  match t with
  | Number value -> value
  | Symbol symbol_name ->
    let addr = Symbol_table.find table symbol_name in
    match addr with
    | Some addr -> begin
        match addr with
        | Address.Address addr -> addr
        | Address.Undefined -> failwith (Printf.sprintf "Symbol(%s) undefined" symbol_name)
      end
    | None -> failwith (Printf.sprintf "Symbol(%s) not exist" symbol_name)
