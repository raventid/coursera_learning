type dest =
  | Null
  | M
  | D
  | MD
  | A
  | AM
  | AD
  | AMD

let dest_of_string_exn str =
  match str with
  | "Null" -> Null
  | "M"    -> M
  | "D"    -> D
  | "MD"   -> MD
  | "A"    -> A
  | "AM"   -> AM
  | "AD"   -> AD
  | "AMD"  -> AMD
  | _      -> failwith "Invalid dest"

let dest_of_string str =
  try Ok (dest_of_string_exn str) with
  | Failure message -> Error message

type comp =
  | C_0_0
  | C_0_1
  | C_0_Minus1
  | C_0_D
  | C_0_A
  | C_0_NotD
  | C_0_NotA
  | C_0_MinusD
  | C_0_MinusA
  | C_0_DPlus1
  | C_0_APlus1
  | C_0_DMinus1
  | C_0_AMinus1
  | C_0_DPlusA
  | C_0_DMinusA
  | C_0_AMinusD
  | C_0_DAndA
  | C_0_DOrA
  | C_1_M
  | C_1_NotM
  | C_1_MinusM
  | C_1_MPlus1
  | C_1_MMinus1
  | C_1_DPlusM
  | C_1_DMinusM
  | C_1_MMinusD
  | C_1_DAndM
  | C_1_DOrM

let comp_of_string_exn str =
  match str with
  | "0"   -> C_0_0
  | "1"   -> C_0_1
  | "-1"  -> C_0_Minus1
  | "D"   -> C_0_D
  | "A"   -> C_0_A
  | "!D"  -> C_0_NotD
  | "!A"  -> C_0_NotA
  | "-D"  -> C_0_MinusD
  | "-A"  -> C_0_MinusA
  | "D+1" -> C_0_DPlus1
  | "A+1" -> C_0_APlus1
  | "D-1" -> C_0_DMinus1
  | "A-1" -> C_0_AMinus1
  | "D+A" -> C_0_DPlusA
  | "D-A" -> C_0_DMinusA
  | "A-D" -> C_0_AMinusD
  | "D&A" -> C_0_DAndA
  | "D|A" -> C_0_DOrA
  | "M"   -> C_1_M
  | "!M"  -> C_1_NotM
  | "-M"  -> C_1_MinusM
  | "M+1" -> C_1_MPlus1
  | "M-1" -> C_1_MMinus1
  | "D+M" -> C_1_DPlusM
  | "D-M" -> C_1_DMinusM
  | "M-D" -> C_1_MMinusD
  | "D&M" -> C_1_DAndM
  | "D|M" -> C_1_DOrM
  | _     -> failwith "Invalid comp"

let comp_of_string str =
  try Ok (comp_of_string_exn str) with
  | Failure message -> Error message

type jump =
  | Null
  | JGT
  | JEQ
  | JGE
  | JLT
  | JNE
  | JLE
  | JMP

let jump_of_string_exn str =
  match str with
  | "Null" -> Null
  | "JGT"  -> JGT
  | "JEQ"  -> JEQ
  | "JGE"  -> JGE
  | "JLT"  -> JLT
  | "JNE"  -> JNE
  | "JLE"  -> JLE
  | "JMP"  -> JMP
  | _      -> failwith "Invalid jump"

let jump_of_string str =
  try Ok (jump_of_string_exn str) with
  | Failure message -> Error message

type t =
  { dest : dest;
    comp : comp;
    jump : jump; }

let create dest comp jump =
  { dest; comp; jump }

let dest_to_code (dest:dest) =
  match dest with
  | Null -> 0b000
  | M    -> 0b001
  | D    -> 0b010
  | MD   -> 0b011
  | A    -> 0b100
  | AM   -> 0b101
  | AD   -> 0b110
  | AMD  -> 0b111

let comp_to_code (comp:comp) =
  match comp with
  | C_0_0       -> 0b0101010
  | C_0_1       -> 0b0111111
  | C_0_Minus1  -> 0b0111010
  | C_0_D       -> 0b0001100
  | C_0_A       -> 0b0110000
  | C_0_NotD    -> 0b0001101
  | C_0_NotA    -> 0b0110001
  | C_0_MinusD  -> 0b0001111
  | C_0_MinusA  -> 0b0110011
  | C_0_DPlus1  -> 0b0011111
  | C_0_APlus1  -> 0b0110111
  | C_0_DMinus1 -> 0b0001110
  | C_0_AMinus1 -> 0b0110010
  | C_0_DPlusA  -> 0b0000010
  | C_0_DMinusA -> 0b0010011
  | C_0_AMinusD -> 0b0000111
  | C_0_DAndA   -> 0b0000000
  | C_0_DOrA    -> 0b0010101
  | C_1_M       -> 0b1110000
  | C_1_NotM    -> 0b1110001
  | C_1_MinusM  -> 0b1110011
  | C_1_MPlus1  -> 0b1110111
  | C_1_MMinus1 -> 0b1110010
  | C_1_DPlusM  -> 0b1000010
  | C_1_DMinusM -> 0b1010011
  | C_1_MMinusD -> 0b1000111
  | C_1_DAndM   -> 0b1000000
  | C_1_DOrM    -> 0b1010101

let jump_to_code (jump:jump) =
  match jump with
  | Null -> 0b000
  | JGT  -> 0b001
  | JEQ  -> 0b010
  | JGE  -> 0b011
  | JLT  -> 0b100
  | JNE  -> 0b101
  | JLE  -> 0b110
  | JMP  -> 0b111

let to_code {dest; comp; jump} =
  let dest_code = dest_to_code dest in
  let comp_code = comp_to_code comp in
  let jump_code = jump_to_code jump in
  (0b111 lsl 13) lor (comp_code lsl 6) lor (dest_code lsl 3) lor jump_code
