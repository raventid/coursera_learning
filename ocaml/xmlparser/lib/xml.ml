type tag_name = string

type value =
  | Nested of tag_name * value list
  | Leaf of tag_name * string
