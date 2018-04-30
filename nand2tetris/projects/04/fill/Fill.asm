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


// Genereal notes about screen:
// Base screen address = 16384 (base address of the Hack screen)
// (512 * 32) / 16  // size of screen
// count = 8192 (# of bytes)
// -1 stands for black screen(in personal folder there is some explanation)
// 0 stands for white screen(in personal folder there is some explanation)

(INIT)
  @24576
  D=A
  @last_screen_address
  M=D

(INPUT)
  @SCREEN
  D=A
  @index
  M=D // set index to beginning of the screen

	@KBD
	D=M

  @SET_COLOR_TO_BLACK
  D;JNE

  @SET_COLOR_TO_WHITE
  D;JEQ

(SET_COLOR_TO_BLACK)
  @color
  M=-1

  @LOOP
  0;JMP

(SET_COLOR_TO_WHITE)
  @color
  M=0

  @LOOP
  0;JMP

(LOOP)
	@index // create index to iterate over screen
	D=M // set D to content of iterator

	@last_screen_address
  D=D-M // set D to (index - count)

	@INPUT
	D;JEQ // if index - count = 0 goto INIT

  @color
  D=M // set D to color we want to use

  @index
  A=M // set A register to required address, we store current screen address in @index
  M=D // set Memory of index to correct color

  @index
  M=M+1 // set screen pointer to point to next memory register

  @LOOP
  0;JMP // goto LOOP
