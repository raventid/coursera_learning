// Program: Iteration.asm
// for(i=0; i<n; i++) {
//   arr[i] = -1
// }

// Suppose that arr=100 and n=10

// arr = 100
@100 // set A register to 100, set M register to content of Memory[100]
D=A
@arr // asks asembler to find first available memory slot and sets A to this slot number (here 16 I suppose), set M register to content of Memory[16]
M=D // D equals 100, so Memory[16] = 100

// n = 10
@10 // set A register to 10, set M register to content of Memory[10]
D=A // sets D to 10
@n // asks assembler to find first available memeory slot and sets A to this slot number (here 17), set M register to content of Memory[17]
M=D // D equals to 10, so Memory[17] = 10

// i=0
@i // asks assembler to find first available memory slot and sets A to this slot number (here 18), set M register to content of Memory[18]
M=0 // Memory[18] = 0


(LOOP)
  // if(i==n) goto END
  @i // we already got some address for @i(it's 18) so we set A to 18
  D=M // D equal to Memory[18], it is 0 at first iteration
  @n // we already got some address for @n(it's 17) so we set A to 17
  D=D-M // D equal to 0 - 10, so it is -10
  @END // Set A register to address of END lable.
  D;JEQ // jump to end if D equals to 0

  // RAM[arr+i] = -1
  @arr // array starts with address 16, so A = 16
  D=M // D equals to what we have in Memory[16], at the beginning this is 100
  @i // let's get back to @i, at the beginning this is 18
  A=D+M // We assign directly to address register, new stuff we assign content of Memory[16], which is 100 + what we have @i this is 0
  M=-1 // now address is 100, and we put -1 at this address

  // i++
  @i // set A to 18 again
  M=M+1 // change i from 0 to 1, at first run

  @LOOP
  0;JMP // unconditional jump, does not matter what happens, just jump to label

(END)
  @END
  0;JMP // uncoditional jump to END. It's infinite loop to avoid NOP slide attack(kinda).

