#![allow(non_camel_case_types)]
#![allow(unused_variables)]
#![allow(dead_code)]

extern crate regex;

// use std::path::Path;

mod parser;
use parser::Parser;

mod code_writer;
use code_writer::CodeWriter;

mod command;
use command::Command;
use command::Command::*;

fn main() {
    // BasicTest file to test VmTranslator located here:
    // /Users/julian/Experiments/coursera_learning/nand2tetris/projects/07/MemoryAccess/BasicTest/BasicTest.vm
    // 1) parser: start parser stream

    let target_input = "/Users/julian/Experiments/coursera_learning/nand2tetris/projects/07/MemoryAccess/BasicTest/BasicTest.vm".to_string();

    // add error handling
    let mut parser = Parser::new(target_input);


    // 2) code_writer: start outup stream
    let target_file = "./BasicTest.asm".to_string();
    // let target_file = Path::new("./BasicTest.asm");
    // let display = target_file.display();

    let mut code_writer =
         match CodeWriter::new(target_file) {
            Err(why) => panic!("couldn't create {}: {}",
                               "./BasicTest.asm",
                               why),
            Ok(writer) => writer,
        };


    // 3) parser: if next_command exist
    loop {
        let (end_of_stream, correct_command) = parser.has_more_commands();
        if !end_of_stream && correct_command {
            // 4) parser: advance
            parser.advance();
            // 4) parser: send me command and token type
            // let command_type = parser.command_type();
            // println!("{:?}", parser.current_command);
            compile(&mut code_writer, &parser.current_command);
        }

        if end_of_stream {
            break
        }
        // 5) code_writer: dispatche type of token and match against machine representation
    }
    // 7) parser: close file
    // parser.close_stream();
    // 8) code_writer: close file
    // code_writer.close_stream();
}

pub fn compile(code_writer : &mut CodeWriter, command : &Command) {
    match command {
        &C_ARITHMETIC { ref raw, ref opcode } => code_writer.write_arithmetic(raw, opcode),
        &C_PUSH { ref raw, ref segment, ref index } => code_writer.write_push_pop(raw, segment, index),
        &C_POP { ref raw, ref segment, ref index } => code_writer.write_push_pop(raw, segment, index),
        &C_LABEL => println!("undefined"),
        &C_GOTO => println!("undefined"),
        &C_IF => println!("undefined"),
        &C_FUNCTION => println!("undefined"),
        &C_RETURN => println!("undefined"),
        &C_CALL => println!("undefined"),
    }
}
