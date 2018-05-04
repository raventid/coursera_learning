#![allow(non_camel_case_types)]
#![allow(unused_variables)]
#![allow(dead_code)]

mod parser;
use parser::Parser;

mod code_writer;

fn main() {
    // BasicTest file to test VmTranslator located here:
    // /Users/julian/Experiments/coursera_learning/nand2tetris/projects/07/MemoryAccess/BasicTest/BasicTest.vm
    // 1) parser: start parser stream

    let target_input = "/Users/julian/Experiments/coursera_learning/nand2tetris/projects/07/MemoryAccess/BasicTest/BasicTest.vm".to_string();

    let mut parser = Parser::new(target_input);

    // 2) code_writer: start outup stream
    // let code_writer = CodeWriter::new(target_output);


    // 3) parser: if next_command exist
    loop {
        let (end_of_stream, correct_command) = parser.has_more_commands();
        if !end_of_stream && correct_command {
            // 4) parser: advance
            parser.advance();
            // 4) parser: send me command and token type
            let command_type = parser.command_type();
            println!("{}", parser.current_command.1);
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
