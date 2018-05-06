use std::io::{ Write, LineWriter, Error };
use std::result::Result;
use std::fs::File;

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
        let helper_comment = format!("// {}\n", raw);
        let code = format!("opcode is {:?}\n", opcode);
        self.target_descriptor.write(&helper_comment.into_bytes());
        self.target_descriptor.write(&code.into_bytes());
    }

    // Writes assembly for push and pop commands
    pub fn write_push_pop(&mut self, raw : &String, segment : &String, index : &usize) {
        let helper_comment = format!("// {}\n", raw);
        self.target_descriptor.write(&helper_comment.into_bytes());

        let at = format!("@{}\n", index);
        self.target_descriptor.write(&at.into_bytes());

        let action = format!("D=A\n");
        self.target_descriptor.write(&action.into_bytes());

        let set_stack_pointer = format!("@SP\n");
        self.target_descriptor.write(&set_stack_pointer.into_bytes());

        let move_address_to_current_stack_pointer = format!("A=M\n");
        self.target_descriptor.write(&move_address_to_current_stack_pointer.into_bytes());

        let move_value_to_stack = format!("M=D\n");
        self.target_descriptor.write(&move_value_to_stack.into_bytes());

        let set_stack_pointer = format!("@SP\n");
        self.target_descriptor.write(&set_stack_pointer.into_bytes());

        let bump_stack_pointer = format!("M=M+1\n");
        self.target_descriptor.write(&bump_stack_pointer.into_bytes());
    }
}

// Just closes the file
fn close() {

}
