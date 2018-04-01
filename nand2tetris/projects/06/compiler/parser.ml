open Core
open Re2

type t =
  { file_name       : string;
    in_channel      : In_channel.t;
    mutable line_no : int }

let line_no t =
  t.line_no

exception Parse_error of t * string

let create file_name =
  let in_channel = In_channel.create ~binary:true file_name in
  let line_no = 0 in
  {file_name; in_channel; line_no}

let is_ignore_line line =
  let open Regex in
  let ignore_re = create_exn "^\\s*(?://.*)?$" in
  matches ignore_re line

let parse_label line =
  let open Regex in
  let symbol_name = find_first_exn
      ~sub:(`Index 1)
      (create_exn "^\\s*\\(([^(]+)\\)\\s*(?://.*)?")
      line in
  Ok (Hack_command.Label symbol_name)

let parse_a_op_address address =
  let number_re = Regex.create_exn "^\\d+$" in
  let is_number = Regex.matches number_re address in
  if is_number then
    Ok (Address_operation.Number (Int.of_string address))
  else
    Ok (Address_operation.Symbol address)

let parse_a_op line =
  let open Regex in
  let address = find_first
      ~sub:(`Index 1)
      (create_exn "^\\s*@([^\\s]+)\\s*(?://.*)?")
      line in
  match address with
  | Ok address2 -> begin
      let address3 = parse_a_op_address address2 in
      match address3 with
      | Ok address4 -> Ok (Hack_command.A_OP address4)
      | Error _ as error -> error
    end
  | Error _ -> Error "Address syntax error"

let parse_c_op line =
  let open Regex in
  let c_op_re = create_exn "^\\s*((\\w+)=)?([^=;\\s]+)(;(\\w+))?\\s*(?://.*)?" in
  let matches = find_submatches c_op_re line in
  match matches with
  | Ok matches' -> begin
      let dest_str = Option.value matches'.(2) ~default:"Null"  in
      let comp_str = Option.value_exn matches'.(3) in
      let jump_str = Option.value matches'.(5) ~default:"Null" in
      let dest = Command_operation.dest_of_string dest_str in
      match dest with
      | Error _ as error -> error
      | Ok dest' ->
        let comp = Command_operation.comp_of_string comp_str in
        match comp with
        | Error _ as error -> error
        | Ok comp' ->
          let jump = Command_operation.jump_of_string jump_str in
          match jump with
          | Error _ as error -> error
          | Ok jump' -> begin
              Ok (Hack_command.C_OP (Command_operation.create dest' comp' jump'))
            end
    end
  | Error _ -> Error "C command syntax error"


let parse_exn t line =
  let is_label =
    let label_re = Regex.create_exn "^\\s*\\([^(]+\\)\\s*" in
    Regex.matches label_re line in
  let is_a_op =
    let a_op_re = Regex.create_exn "^\\s*@" in
    Regex.matches a_op_re line in
  let command =
    if is_label then
      parse_label line
    else if is_a_op then
      parse_a_op line
    else
      parse_c_op line in
  match command with
  | Ok command' -> command'
  | Error message ->
    raise (Parse_error (t, message))

let rec read_command_line t =
  let line = In_channel.input_line t.in_channel in
  t.line_no <- t.line_no + 1;
  match line with
  | Some line -> begin
      if is_ignore_line line then
        ((* printf "ignore : %3d %2d [%s]\n" t.line_no (String.length line) line; *)
         read_command_line t)
      else
        ((* printf "command: %3d %2d [%s]\n" t.line_no (String.length line) line; *)
         Some line)
    end
  | None -> None

let next_command t =
  let line = read_command_line t in
  match line with
  | Some line -> Some (parse_exn t line)
  | None -> None

