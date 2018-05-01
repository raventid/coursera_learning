# Build

This project uses `dune` build system (`jbuilder` in the past), by Jane Street.
Also I use `Core` by Jane Street. 

Thank you Jane Street!

To start a build run:

```
jbuilder build main.exe
```

To compile your program run:

```
path/to/main.exe path/to/your_file.asm
```

Your .hack file will be created in the same folder as an .asm file.

### General notes

If you would like to play with some part of this code in `utop` you
should first require `#require "base"` before you actually `open Base;;`.
