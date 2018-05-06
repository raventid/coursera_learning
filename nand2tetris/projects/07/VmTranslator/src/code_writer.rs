use std::io::{ Error };
use std::result::Result;
use std::fs::File;
use std::io::LineWriter;
use std::io::Write;

pub struct CodeWriter {
    target_descriptor: LineWriter<File>
}

impl CodeWriter {
    // Opens the output file, and gets ready to write into it
    pub fn new(target_file : String) -> Result<Self, Error> {
        let file = File::create(target_file)?;
        let line_writer = LineWriter::new(file);

        Ok( CodeWriter{ target_descriptor: line_writer} )
    }

    // Writes to the file assembly code which represents current arithmetic command
    pub fn write_arithmetic(&mut self, raw : &String, opcode : &String) {
        let code = format!("opcode is {:?}", opcode);
        self.target_descriptor.write_all(&code.into_bytes());
    }

    // Writes assembly for push and pop commands
    pub fn write_push_pop(&mut self, raw : &String, segment : &String, index : &usize) {
        let code = format!("segment is {:?}", segment);
        self.target_descriptor.write_all(&code.into_bytes());
    }
}

// Just closes the file
fn close() {

}
