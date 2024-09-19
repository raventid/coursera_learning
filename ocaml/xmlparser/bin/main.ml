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
      List.iter (print_ast (indent ^ "  ")) children

let () =
  let xml = "<a><i></i><j>text</j></a>" in
  let lexbuf = Lexing.from_string xml in
  match parse_with_error lexbuf with
  | Some value ->
      print_endline "Parsed AST:";
      print_ast "" value
  | None -> print_endline "Failed to parse XML"
