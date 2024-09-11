open Core
open Lexerparser
open Lexing

let print_error_position output_channel lexical_buffer =
  let buffer_current_position = lexical_buffer.lex_curr_p in
  fprintf output_channel "%s:%d:%d"
    buffer_current_position.pos_fname
    buffer_current_position.pos_lnum
    (buffer_current_position.pos_cnum - buffer_current_position.pos_bol + 1)

let parse_with_error_handling lexical_buffer =
  let parse = Parser.prog Lexer.read in
    try
       parse lexical_buffer
    with
    | Lexer.SyntaxError error_message ->
      fprintf stderr "%a: %s\n" print_error_position lexical_buffer error_message;
      None
    | Parser.Error ->
      fprintf stderr "%a: parser failed with a syntax error\n" print_error_position lexical_buffer;
      -1 |> exit

let rec parse_and_print_json lexical_buffer =
  match parse_with_error_handling lexical_buffer with
  | Some json_value ->
    printf "%a\n" Json.output_value json_value;
    parse_and_print_json lexical_buffer
  | None -> ()

let process_json_file filename () =
  let input_channel = In_channel.create filename in
  let lexical_buffer = Lexing.from_channel input_channel in
  lexical_buffer.lex_curr_p <- { lexical_buffer.lex_curr_p with pos_fname = filename };
  parse_and_print_json lexical_buffer;
  In_channel.close input_channel

let () =
  Command.basic_spec
    ~summary:"Parse and display JSON"
    Command.Spec.(empty +> anon ("filename" %: string))
    process_json_file
  |> Command_unix.run
