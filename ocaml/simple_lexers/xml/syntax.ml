type token =
  | LEFT_QUOTE
  | RIGHT_QUOTE
  | SLASH
  | TEXT of string
  | EOF
  [@@deriving show]

exception SyntaxError of string
