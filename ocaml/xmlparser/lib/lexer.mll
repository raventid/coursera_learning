{
open Parser  (* The type token is defined in parser.mli *)
exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  lexbuf.Lexing.lex_curr_p <-
    { pos with Lexing.pos_bol = lexbuf.Lexing.lex_curr_pos;
               Lexing.pos_lnum = pos.Lexing.pos_lnum + 1
    }
}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let text = [^ '<' '>' '/' '"' '\'' '\r' '\n']+

rule read =
  parse
  | white    { read lexbuf }
  | newline  { next_line lexbuf; read lexbuf }
  | '<'      { LEFT_QUOTE }
  | "</"     { CLOSING_LEFT_QUOTE }
  | '>'      { RIGHT_QUOTE }
  | text     { TEXT (Lexing.lexeme lexbuf) }
  | eof      { EOF }
  | _        { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
