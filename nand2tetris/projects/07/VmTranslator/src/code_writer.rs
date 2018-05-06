use std::io::{ Write, LineWriter, Error };
use std::result::Result;
use std::fs::File;
use std::collections::HashMap;

static STACK_POINTER: &'static str = "SP";

lazy_static! {
    static ref MEMORY_SEGMENT_BASE: HashMap<&'static str, &'static str> = {
        let mut map = HashMap::new();
        map.insert("local", "LCL");
        map.insert("argument", "ARG");
        map.insert("this", "THIS");
        map.insert("that", "THAT");
        map.insert("temp", "5"); // this is very special segment
        map
    };
}

pub struct CodeWriter {
    target_descriptor: LineWriter<File>
}

impl CodeWriter {
    // Opens the output file, and gets ready to write into it
    pub fn new(target_file : String) -> Result<Self, Error> {
        let file = File::create(target_file)?;
        let line_writer = LineWriter::new(file);

        Ok( CodeWriter{ target_descriptor: line_writer } )
    }

    // Writes to the file assembly code which represents current arithmetic command
    pub fn write_arithmetic(&mut self, raw : &String, opcode : &String) {
        let helper_comment = format!("// {}\n", raw);
        self.target_descriptor.write(&helper_comment.into_bytes());


        let code = format!(
            "@{stack_pointer}
M=M-1
A=M
D=M // take first argument for operation

@{register1}
M=D

@{stack_pointer}
M=M-1
A=M
D=M // take second argument for operation

@{register1}
D=D-M // perform your action

@{stack_pointer}
A=M // move to memory cell pointed by stack_pointer
M=D // put operation result to this cell",
            stack_pointer=STACK_POINTER,
            register1="R13"
        );
        self.target_descriptor.write(&code.into_bytes());
    }

    // Writes assembly for push and pop commands
    pub fn write_push(&mut self, raw : &String, segment : &String, index : &usize) {
        let helper_comment = format!("// {}\n", raw);
        self.target_descriptor.write(&helper_comment.into_bytes());

        if segment.starts_with("constant") {
            let at = format!("@{}\n", index);
            self.target_descriptor.write(&at.into_bytes());

            let action = format!("D=A\n");
            self.target_descriptor.write(&action.into_bytes());

            let set_stack_pointer = format!("@{}\n", STACK_POINTER);
            self.target_descriptor.write(&set_stack_pointer.into_bytes());

            let move_address_to_current_stack_pointer = format!("A=M\n");
            self.target_descriptor.write(&move_address_to_current_stack_pointer.into_bytes());

            let move_value_to_stack = format!("M=D\n");
            self.target_descriptor.write(&move_value_to_stack.into_bytes());

            let set_stack_pointer = format!("@{}\n", STACK_POINTER);
            self.target_descriptor.write(&set_stack_pointer.into_bytes());

            let bump_stack_pointer = format!("M=M+1\n");
            self.target_descriptor.write(&bump_stack_pointer.into_bytes());
        } else if segment.starts_with("local") || segment.starts_with("argument") ||
        segment.starts_with("this") || segment.starts_with("that") || segment.starts_with("temp") {
            let code = format!(
                "@{index}
D=A // save shift from base to D register
@{local_base}
D=D+M // save shift + base_address to D register
A=D // set memory to shift + base_address
D=M // save content of memory to D register
@{stack_pointer} // set addr to stack_pointer
A=M // move to this cell
M=D // set content of this cell in stack to be conent of memory segment
@{stack_pointer}
M=M+1 // bump stack_pointe, so it points to new empty mem_cell
",
                index=index,
                local_base=MEMORY_SEGMENT_BASE.get::<str>(&segment).unwrap(),
                stack_pointer=STACK_POINTER
            );
            self.target_descriptor.write(&code.into_bytes());

        } else if segment.starts_with("static") {
            let code = format!(
                    "@Foo.{index}
D=M // save static var to D reg
@{stack_pointer}
M=D // go to current stack pointer
A=M // follow pointer to current free cell
M=D // fill this cell with static var value
@{stack_pointer}
M=M+1 // bump stack pointer
",
                index=index,
                stack_pointer=STACK_POINTER
            );
            self.target_descriptor.write(&code.into_bytes());
        } else if segment.starts_with("pointer") {
            let code = format!(
                "@{segment}
D=M // put this/that pointer base into D

@{stack_pointer}
A=M // Follow stack pointer to current free memory cell
M=D // Set value of this cell to be this/that

@{stack_pointer}
M=M+1 // bump stack pointer
",
                segment=if *index == (0 as usize) {
                    MEMORY_SEGMENT_BASE.get::<str>("this").unwrap()
                } else {
                    MEMORY_SEGMENT_BASE.get::<str>("that").unwrap()
                },
                stack_pointer=STACK_POINTER
            );

            self.target_descriptor.write(&code.into_bytes());
        }
    }

    // Writes assembly for push and pop commands
    pub fn write_pop(&mut self, raw : &String, segment : &String, index : &usize) {
        let helper_comment = format!("// {}\n", raw);
        self.target_descriptor.write(&helper_comment.into_bytes());

        if segment.starts_with("this") || segment.starts_with("that") ||
            segment.starts_with("local") || segment.starts_with("argument") || segment.starts_with("temp") {
                // works for local segment
                let code = format!(
                    "@{index}
D=A // save shift from base to D register
@{local_base}
D=D+M // save shift + base_address to D register
@{tmp_register}
M=D // save pop target to @R13
@{stack_pointer} // set addr to stack_pointer
M=M-1 // unbump stack_pointer, so it points to last real value
A=M // follow stack pointer and see what we have there
D=M // put
@{tmp_register}
A=M // jump to target we saved in R13
M=D // put value popped out of a stack to target memory cell
",
                    index=index,
                    local_base=MEMORY_SEGMENT_BASE.get::<str>(&segment).unwrap(),
                    tmp_register="R13",
                    stack_pointer=STACK_POINTER
                );
                self.target_descriptor.write(&code.into_bytes());
            } else if segment.starts_with("static") {
                let code = format!(
                    "@{stack_pointer}
M=M-1 // unbump stack pointer
A=M // follow pointer
D=M // save it in D register
@Foo.{index}
M=D // save D reg value in static var
",
                    index=index,
                    stack_pointer=STACK_POINTER
                );
                self.target_descriptor.write(&code.into_bytes());
            } else if segment.starts_with("pointer") {
                let code = format!(
                    "@{stack_pointer}
M=M-1 // unbump stack pointer to point to last real value
A=M // Follow stack pointer to memory cell
D=M // Set D register to contain required value

@{segment}
M=D // put D reg value to this/that
",
                    segment=if *index == (0 as usize) {
                        MEMORY_SEGMENT_BASE.get::<str>("this").unwrap()
                    } else {
                        MEMORY_SEGMENT_BASE.get::<str>("that").unwrap()
                    },
                    stack_pointer=STACK_POINTER
                );

                self.target_descriptor.write(&code.into_bytes());
            }
    }
}
