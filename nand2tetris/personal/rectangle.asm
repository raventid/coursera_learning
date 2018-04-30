// Program: Rectangle.asm
// Draws a filled rectangle at the screen's top left corner.
// The rectangle's width is 16 pixels, and its height is RAM[0]
// Usage: put a non-negtive number (rectangle's height) in RAM[0]

  @R0 // register R0 is predefined. It sets A to 0.
  D=M // move content of M[0] to D register, it is 0.
  @n // find first available memory slot for @n. It is 16. (after all of the R registers)
  M=D // n = RAM[0]

  @i // find first available memory slot for @i. It is 17.
  M=0 // i = 0

  @SCREEN // set A register to magic @SCREEN symbol.
  D=A // move this address to D register
  @screen_address // find first available slot for @screen_address. It is 18.
  M=D // screen_address = 16384 (base address of the Hack screen)

(LOOP)
  @i // set A register to @i symbol registered address. It is 17.
  D=M // move to D content of @i
  @n // set A register to @n symbol registerered address. It is 16.
  D=D-M // set D to previous D (content of @i) - content of n
  @END
  D;JGT // if i>n goto END ( if i - n > 0 goto END )

  @screen_address // find screen_address. Sets A register to 18.
  A=M // Content of memory_slot 18 is the address of screen -> 16384. Set A register to this address.
  M=-1 // RAM[address] = -1 (16 pixels) (-1 == 1111111111111111)

  @i // set A register to slot 17. M is equal to content of slot 17.
  M=M+1 // i = i + 1
  // we use 32 words to represent a row of screen
  // 32 x 16 = 512 points on screen
  // first row of screen: x16384: [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000]	[0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000]

  // second row of screen: x16416: [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000] [0000000000000000]

  @32 // set A register to slot 32.
  D=A // just move 32 to D.
  @screen_address // find screen_address. Sets A register to 18.
  M=D+M // address = address + 32 // we take content of M it's an address of screen (16384 at first run), and we add 32 to it.
  // so we start to pointing not to the beginning of a screen, but to the moved point. (32 bits)
  @LOOP
  0;JMP // goto LOOP

(END)
  @END
  0;JMP // cycle the programm to avoid NOP slide
