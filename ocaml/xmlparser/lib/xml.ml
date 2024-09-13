type tag_name = string

type value =
  | List of tag_name * value list
  | Leaf of tag_name * string
