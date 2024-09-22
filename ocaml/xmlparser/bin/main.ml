open Core
open Xmlparser

let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | Lexer.SyntaxError msg ->
      Printf.fprintf stderr "%s%!" msg;
      None
  | Parser.Error ->
      Printf.fprintf stderr "Syntax error\n%!";
      None

let rec print_ast indent = function
  | Xml.Leaf (tag, content) ->
      Printf.printf "%s%s: %s\n" indent tag content
  | Nested (tag, children) ->
      Printf.printf "%s%s:\n" indent tag;
      List.iter ~f:(print_ast (indent ^ "  ")) children

let process_xml_file filename () =
  let input_channel = In_channel.create filename in
  let lexical_buffer = Lexing.from_channel input_channel in
  lexical_buffer.lex_curr_p <- { lexical_buffer.lex_curr_p with pos_fname = filename };
  match parse_with_error lexical_buffer with
  | Some value ->
      print_endline "Parsed AST:";
      print_endline "";
      print_ast "" value
  | None -> print_endline "Failed to parse XML";
  In_channel.close input_channel

let () =
  Command.basic_spec
    ~summary:"Parse and display JSON"
    Command.Spec.(empty +> anon ("filename" %: string))
    process_xml_file
  |> Command_unix.run
