// Program: Sum1toN.asm
// Computes RAM[1] = 1 + 2 + ... + n
// Usage: put a number (n) in RAM[0]

// Algorithm:
//
// Declaration:
// n = R0
// i = 1
// sum = 0
//
// LOOP:
//   if i > n goto STOP
//   sum = sum + i
//   i = i + 1
//   goto LOOP
// STOP:
//   R1 = sum


// Declaration:
@R0
D=M

@n
M=D // n = R0

@i
M=1 // i = 1

@sum
M=0 // sum = 0


(LOOP)
  @i
  D=M
  @n
  D=D-M
  @STOP
  D;JGT // if i > n goto STOP (perhaps switch to `i - n > 0` comment? explains everything much better)
  @sum
  D=M
  @i
  D=D+M
  @sum
  M=D // sum = sum + i
  @i
  M=M+1 // i = i + 1
  @LOOP
  0;JMP

(STOP)
  @sum
  D=M
  @R1
  M=D // RAM[1] = sum

(END)
  @END
  0;JMP
