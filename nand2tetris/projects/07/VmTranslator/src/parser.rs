use std::io::{ BufReader };
use std::io::prelude::*;
use std::fs::File;
use regex::Regex;

use command::Command;

pub struct Parser {
    pub current_command: Command,

    target_descriptor: BufReader<File>,
    next_command: Command
}

impl Parser {
    // Opens file/stream, make every other component ready to handle it
    pub fn new(input_file : String) -> Self {
        let f = File::open(input_file).unwrap();
        let b = BufReader::new(f);

        Parser {
            target_descriptor: b,
            current_command: Command::C_CALL,
            next_command: Command::C_CALL
        }
    }

    // Are there more command in the input?
    // (bool, bool) - first one IsEndOfInput?, second one is CorrectCommand
    pub fn has_more_commands(&mut self) -> (bool, bool) {
        for line in self.target_descriptor.by_ref().lines() {
            if let Ok(str) = line {
                if ignore_this_line(&str)  {
                    return (false, false)
                } else {
                    self.next_command = command_type(str);
                    return (false, true)
                }
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

}

fn ignore_this_line(line : &String) -> bool {
    line.starts_with("//") || line.is_empty()
}

// Returns enum variant representing the current_command. I might not need it, because I can pattern match :)
#[allow(unreachable_code)]
fn command_type(command : String) -> Command {
    // It's not very smart to compile regexp every time.
    // Gonna fix it later.
    let push_regexp = Regex::new(r"push ([a-z]*) ([0-9]*)").unwrap();
    if let Some(cap) = push_regexp.captures(&command) {
        return Command::C_PUSH {
            raw: cap[0].to_string(),
            segment: cap[1].to_string(),
            index: cap[2].parse().unwrap()
        };
    }

    let pop_regexp = Regex::new(r"pop ([a-z]*) ([0-9]*)").unwrap();
    if let Some(cap) = pop_regexp.captures(&command) {
        return Command::C_POP {
            raw: cap[0].to_string(),
            segment: cap[1].to_string(),
            index: cap[2].parse().unwrap()
        };
    }

    let arithmetic_regexp = Regex::new(r"(add|sub|neg|eq|gt|lt|and|or|not)").unwrap();
    if let Some(cap) = arithmetic_regexp.captures(&command) {
        return Command::C_ARITHMETIC {
            raw: cap[0].to_string(),
            opcode: cap[1].to_string()
        };
    }

    Command::C_ARITHMETIC {
        raw: "".to_string(),
        opcode: "".to_string()
    }
}
