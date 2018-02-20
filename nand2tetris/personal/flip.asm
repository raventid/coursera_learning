// Program: Flip.asm
// flips the values of
// RAM[0] and RAM[1]

// temp = R1
// R1 = R0
// R0 = temp

@R1
D=M
@temp // asm go and find some available register, where I can store my information
M=D

@R0
D=M
@R1
M=D

@temp
D=M
@R0
M=D

(END)
  @END
  0;JMP

// in this assembler dialect we'll have the next rules
// 1) A reference to a symbol that has no corresponding label
//    declaration is treated as a reference to a variable.
// 2) Variables are allocated to the RAM from address 16 onward.
