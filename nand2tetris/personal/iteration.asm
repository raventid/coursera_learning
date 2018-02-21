// Program: Iteration.asm
// for(i=0; i<n; i++) {
//   arr[i] = -1
// }

// Suppose that arr=100 and n=10

// arr = 100
@100
D=A
@arr
M=D

// n = 10
@10
D=A
@n
M=D

// i=0
@i
M=0


(LOOP)
  // if(i==n) goto END
  @i
  D=M
  @n
  D=D-M
  @END
  D;JEQ

  // RAM[arr+i] = -1
  @arr
  D=M
  @i
  A=D+M // We assign directly to address register, new stuff
  M=-1

  // i++
  @i
  M=M+1

  @LOOP
  0;JMP // How does this couple of instructions work?

(END)
  @END
  0;JMP // And this couple of instructions too? Do we jump to a register? Forgot.

