(* Opens the output file, and gets ready to write into it *)
let constructor = open "output_file"

(* Writes to the file assembly code which represents current arithmetic command *)
let writeArithmetic = "some command"

(* Writes assembly for push and pop commands *)
let writePushPop = "push and pop command"

(* Just closes the file *)
let close = close "output_file"
