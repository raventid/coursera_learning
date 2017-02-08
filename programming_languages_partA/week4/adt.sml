datatype set = s of { insert: int->set, (* type does not support recursive definition *)
                      member: int->bool,
                      size:   unit->int }

val empty_set = 
  let 
    fun make_set xs =
      let 
        fun contains i = List.exists(fn j => i=j) xs
      in
        s { insert = fn i => if contains i
                            then make_set xs
                            else make_set(i::xs),
            member = contains,
            size = fn () => length xs  
          }
      end
  in
    make_set []
  end
