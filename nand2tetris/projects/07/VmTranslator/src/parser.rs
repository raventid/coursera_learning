use std::io::{ BufReader };
use std::io::prelude::*;
use std::fs::File;
use std::result::Result;
use std::io::Error;

// All available commands for virtual machine
enum Command {
   C_ARITHMETIC,
   C_PUSH,
   C_POP,
   C_LABEL,
   C_GOTO,
   C_IF,
   C_FUNCTION,
   C_RETURN,
   C_CALL,
}

// Opens file/stream, make every other component ready to handle it
fn constructor(input_file : String) -> Result<(), Error> {
    let f = File::open(input_file)?;
    let f = BufReader::new(f);

    for line in f.lines() {
        println!("{}", line.unwrap());
    }

    Ok(())
}

// Are there more command in the input?
fn has_more_commands(input : String) -> String {
    "Hello".to_string()
}

// Reads next command from the input and makes it the current command
// Should be called only if has_more_commmand is true. Initially - no current_command
fn advance(command : Command) -> bool {
    true
}

// Returns enum variant representing the current_command. I might not need it, because I can pattern match :)
fn command_type(raw_line : String) -> Command {
  Command::C_ARITHMETIC
}
