// Program: Flip.asm
// flips the values of
// RAM[0] and RAM[1]

// temp = R1
// R1 = R0
// R0 = temp

// Whitespace instruction are ignored!!! This can lead to NOP slide if you are not accurate.

@R1
D=M // We are at R1 make: D = Ram[R1]
@temp // asm go and find some available register, where I can store my information
M=D // We are at temp make: Ram[temp] = D

@R0
D=M // We are at R0: D = Ram[R0]
@R1
M=D // We are at R1: Ram[R1] = D

@temp
D=M // We are at temp: D = Ram[temp]
@R0
M=D // We are at R0: Ram[R0] = D

(END)
  @END
  0;JMP

// in this assembler dialect we'll have the next rules
// 1) A reference to a symbol that has no corresponding label
//    declaration is treated as a reference to a variable.
// 2) Variables are allocated to the RAM from address 16 onward.
