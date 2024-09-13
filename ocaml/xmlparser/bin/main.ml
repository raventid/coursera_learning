open Xmlparser

let xml_sample = "<outer></outer>"

let parse_xml input =
  let lexbuf = Lexing.from_string input in
  try
    Parser.prog Lexer.read lexbuf
  with
  | Parser.Error ->
      Printf.fprintf stderr "Syntax error\n";
      None
  | Lexer.SyntaxError msg ->
      Printf.fprintf stderr "Lexer error: %s\n" msg;
      None

let _ = parse_xml xml_sample
let _ = print_endline xml_sample
