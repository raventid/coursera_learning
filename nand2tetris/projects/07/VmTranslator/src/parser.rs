use std::io::{ BufReader };
use std::io::prelude::*;
use std::fs::File;
pub struct Parser {
    target_descriptor: BufReader<File>,
    pub current_command: (Command, String),
    pub next_command: (Command, String)
}

// All available command types for virtual machine
pub enum Command {
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

impl Parser {
    // Opens file/stream, make every other component ready to handle it
    pub fn new(input_file : String) -> Self {
        let f = File::open(input_file).unwrap();
        let b = BufReader::new(f);

        // for line in b.by_ref().lines() {
        //     println!("{}", line.unwrap());
        // }

        Parser { target_descriptor: b, current_command: (Command::C_CALL, "".to_string()), next_command: (Command::C_CALL, "".to_string())}
    }

    // Are there more command in the input?
    // (bool, bool) - first one IsEndOfInput?, second one is CorrectCommand
    pub fn has_more_commands(&mut self) -> (bool, bool) {
        for line in self.target_descriptor.by_ref().lines() {
            if let Ok(str) = line {
                if str.starts_with("push") {
                    self.next_command = (Command::C_CALL, str);
                    return (false, true)
                }
                return (false, false)
            } else {
                // ignore this case
            }
        }
        (true, false)
    }

    // Reads next command from the input and makes it the current command
    // Should be called only if has_more_commmand is true. Initially - no current_command
    pub fn advance(&mut self) -> bool {
        ::std::mem::swap(&mut self.current_command, &mut self.next_command);
        // self.current_command = self.next_command.take();
        true
    }

    // Returns enum variant representing the current_command. I might not need it, because I can pattern match :)
    pub fn command_type(&self) -> Command {
        Command::C_ARITHMETIC
    }
}
