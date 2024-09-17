%{
  open Xml
%}

%token <string> TEXT
%token LEFT_QUOTE
%token RIGHT_QUOTE
%token SLASH
%token EOF

%start <Xml.value option> prog
%%

prog:
  | v = element EOF  { Some v }
  | EOF              { None   };

element:
  | empty_element    { $1 }
  | leaf_element     { $1 }
  | nested_element   { $1 }

empty_element:
  | name = tag_open; close_name = tag_close {
      if name = close_name then
        Leaf (name, "")
      else
        Leaf ("error", "Mismatched tags: " ^ name ^ " and " ^ close_name)
    }

leaf_element:
  | name = tag_open;
    content = TEXT;
    close_name = tag_close {
      if name = close_name then
        Leaf (name, content)
      else
        Leaf ("error", "Mismatched tags: " ^ name ^ " and " ^ close_name)
    }

nested_element:
  | name = tag_open;
    children = nonempty_list(element);
    close_name = tag_close {
      if name = close_name then
        Nested (name, children)
      else
        Nested ("error", [Leaf ("error", "Mismatched tags: " ^ name ^ " and " ^ close_name)])
    }

tag_open: LEFT_QUOTE; name = TEXT; RIGHT_QUOTE; { name }
tag_close: LEFT_QUOTE; SLASH; name = TEXT; RIGHT_QUOTE { name }
