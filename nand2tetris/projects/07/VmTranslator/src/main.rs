#![allow(non_camel_case_types)]
#![allow(unused_variables)]
#![allow(dead_code)]

mod parser;
mod code_writer;

fn main() {
    // BasicTest file to test VmTranslator located here:
    // /Users/julian/Experiments/coursera_learning/nand2tetris/projects/07/MemoryAccess/BasicTest/BasicTest.vm
    println!("Hello, world!");
    // 1) parser: start parser stream
    // 2) code_writer: start outup stream
    // 3) parser: if next_command exist
    // 4) parser: advance
    // 4) parser: send me command and token type
    // 5) code_writer: dispatche type of token and match against machine representation
    // 6) code_writer: do this until parser: next_command exists in file
    // 7) parser: close file
    // 8) code_writer: close file
}
