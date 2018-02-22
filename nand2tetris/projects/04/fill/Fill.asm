// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

(INIT)
  @SCREEN
  D=A
  @screen
  M=D // address = 16384 (base address of the Hack screen)

  @color
  M=-1 // -1 stands for black screen(in personal folder there is some explanation)
  // 0 stands for black screen(in personal folder there is some explanation)

(INPUT)
  @KBD
  D = M

  @SET_COLOR_TO_BLACK
  D;JNE

  @SET_COLOR_TO_WHITE
  D;JEQ

(SET_COLOR_TO_BLACK)
  @color
  M = -1

  @LOOP
  0;JMP

(SET_COLOR_TO_WHITE)
  @color
  M = 0

  @LOOP
  0;JMP

// TODO: It does not work. But I like the overall design much better then any other.
// It would be nice to debug this code and fix.
(LOOP)
  @i
  D=M // We don't need i in fact. I think screen is enough for any operation.
  @n
  D=D-M
  @INIT
  D;JGT // if i>n goto END

  @screen
  A=M

  // I guess something is wrong here. I put something in wrong register?
  @color
  D = M

  @screen
  M = D // set all bits in register to right color

  @i
  M=M+1 // i = i + 1
  @32
  D=A
  @screen
  M=D+M // address = address + 32
  @LOOP
  0;JMP // goto LOOP
