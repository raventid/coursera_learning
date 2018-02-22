// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

@R0
D=M
@first
M=D // Save R0 to Ram[first]

@R1
D=M
@second
M=D // Save R1 to Ram[second]

@i
M=1 // We start LOOP with i=1

@result
M=0 // Result will be 0 for some time

(LOOP)
  // We make fast jump to STOP here, because test program only gives me
  // 20 tacts to perform all of the actions.
  @second
  D=M
  @STOP
  D; JLE // if second == then jump to the end, n * 0 = 0

  @first
  D=M
  @STOP
  D; JLE // if first == then jump to the end, 0 * n = 0

  @i
  D=M
  @second
  D=D-M // D = i - second (on iteration 2: 2 - 10 = -8)

  @STOP
  D;JGT // if i > n goto STOP

  @first
  D=M // Move first value to D

  @result
  M=D+M // sum = sum + @first

  @i
  M=M+1 // i = i + 1

  @LOOP
  0;JMP // unconditional jump to repeat LOOP

(STOP)
  @result
  D=M // take first were we accumulated all of the data
  @R2
  M=D // put value of memory in first into second register

(END)
  @END
  0;JMP
// Put your code here
