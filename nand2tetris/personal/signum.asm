// Program: Signum.asm
// Computes: if R0 > 0
//              R1 = 1
//           else
//              R1 = 0

@R0
D=M

@8
D;JGT

@R1
M=0
@10
0;JMP

@R1
M=1

@10
0;JMP
