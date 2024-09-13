%{
  open Xml  (* Assuming your type definitions are in a module named Xml *)
%}

%token <string> TEXT
%token LEFT_QUOTE
%token RIGHT_QUOTE
%token SLASH
%token EOF

%start <Xml.value option> prog
%%

prog:
  | v = value     { Some v }
  | EOF           { None   }
;

value:
  | list { $1 }
  | leaf { $1 }
;

list:
  | LEFT_QUOTE; name = TEXT; RIGHT_QUOTE;
    content = value_list;
    LEFT_QUOTE; SLASH; close_name = TEXT; RIGHT_QUOTE
    {
      if name = close_name then
        List (name, content)
      else
        raise (Failure ("Mismatched tags: " ^ name ^ " and " ^ close_name))
    }
;

leaf:
  | LEFT_QUOTE; name = TEXT; RIGHT_QUOTE;
    content = TEXT? ;  (* Make content optional *)
    LEFT_QUOTE; SLASH; close_name = TEXT; RIGHT_QUOTE
    {
      if name = close_name then
        Leaf (name, Option.value content ~default:"")
      else
        raise (Failure ("Mismatched tags: " ^ name ^ " and " ^ close_name))
    }
;

value_list:
  | v = value { [v] }
  | v = value; rest = value_list { v :: rest }
;
