%{
  open Xml
  exception MismatchedTags of string * string
%}

%token <string> TEXT
%token LEFT_QUOTE
%token CLOSING_LEFT_QUOTE
%token RIGHT_QUOTE
%token EOF

%start <Xml.value option> prog
%%

prog:
  | v = element EOF  { Some v }
  | EOF              { None   };

element:
  | open_id = tag_open; close_id = tag_close {
    if open_id = close_id then
      Leaf (open_id, "")
    else
      raise (MismatchedTags (open_id, close_id))
  }
  | open_id = tag_open; content = TEXT; close_id = tag_close {
      if open_id = close_id then
        Leaf (open_id, content)
      else
        raise (MismatchedTags (open_id, close_id))
    }
  | open_id = tag_open; content = nested_tags; close_id = tag_close {
      if open_id = close_id then
        Nested (open_id, content)
      else
        raise (MismatchedTags (open_id, close_id))
    }

nested_tags:
  | e = element; l = nested_tags  { e :: l }
  | e = element                   { [e] }

tag_open: LEFT_QUOTE; name = TEXT; RIGHT_QUOTE { name }
tag_close: CLOSING_LEFT_QUOTE; name = TEXT; RIGHT_QUOTE { name }
