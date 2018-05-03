(* Opens file/stream, make every other component ready to handle it *)
let constructor f = open f

(* Are there more command in the input? *)
let has_more_commands i = RowStream.more_commands_available i

(* Reads next command from the input and makes it the current command *)
(* Should be called only if has_more_commmand is true. Initially - no current_command *)
let advance c =
  let current_command = read_command c in
  set_current_command_to current_command


(* Returns enum variant representing the current_command. I might not need it, because I can pattern match :) *)
let command_type =
  C_ARITHMETIC | C_PUSH | C_POP | C_LABEL | C_GOTO | C_IF | C_FUNCTION | C_RETURN | C_CALL
