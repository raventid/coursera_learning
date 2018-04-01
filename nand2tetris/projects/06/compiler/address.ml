(* Optional type which represents address or lack of address *)
type t =
  | Undefined
  | Address of int

let to_string t =
  match t with
  | Undefined -> "undefined"
  | Address addr -> Printf.sprintf "%04x" addr
