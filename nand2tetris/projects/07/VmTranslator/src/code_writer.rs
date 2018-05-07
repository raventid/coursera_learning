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
    target_descriptor: LineWriter<File>,
    arithmetic_counter: u16
}

impl CodeWriter {
    // Opens the output file, and gets ready to write into it
    pub fn new(target_file : String) -> Result<Self, Error> {
        let file = File::create(target_file)?;
        let line_writer = LineWriter::new(file);

        Ok( CodeWriter{ target_descriptor: line_writer, arithmetic_counter: 0 } )
    }

    // Writes to the file assembly code which represents current arithmetic command
    pub fn write_arithmetic(&mut self, raw: &String, opcode: &String) -> () {
        let helper_comment = format!("// {}\n", raw);
        self.target_descriptor.write(&helper_comment.into_bytes());

        match opcode.to_lowercase().as_ref() {
            "add" => self.write_binary("M=D+M"),
            "sub" => self.write_binary("M=M-D"),
            "neg" => self.write_unary("M=-M"),
            "eq"  => self.write_binary_with_jmp("JEQ"),
            "gt"  => self.write_binary_with_jmp("JGT"),
            "lt"  => self.write_binary_with_jmp("JLT"),
            "and" => self.write_binary("M=D&M"),
            "or"  => self.write_binary("M=D|M"),
            "not" => self.write_unary("M=!M"),
            &_ => ()
        }
    }

    fn write_unary(&mut self, operation:&str) -> () {
        let code = format!(
"@{stack_pointer}
A=M-1 // Follow pointer to last real address on stack(we don't decrement pointer here)
{operation} // Perform required operation on memory cell
",
            operation=operation,
            stack_pointer=STACK_POINTER);
        self.target_descriptor.write(&code.into_bytes());
    }

    fn write_binary(&mut self, operation: &str) -> () {
        let code = format!(
"@{stack_pointer}
AM=M-1 // Unbump stack pointer, follow the pointer
D=M // Load the value to D register
A=A-1 // Move to previous address in stack memory region, Once again we do not change
{operation} // Perform operation, set by opcode
",
            stack_pointer=STACK_POINTER,
            operation=operation
        );
        self.target_descriptor.write(&code.into_bytes());
    }

    // Here I'm using the next idea:
    // Let's work through example with `gt`
    // a = stack.pop // first value
    // b = stack.pop // next value
    // c = b - a // get the difference
    // c;JGT
    // Here is the idea: if c > 0 it means that b is greater then
    // a. So gt means that stack[m-2] > stack[m-1].
    fn write_binary_with_jmp(&mut self, jump_type: &str) -> () {
        let code = format!(
"@{stack_pointer}
AM=M-1 // Decrement stack pointer and follow decremented pointer
D=M // Load value of target memory cell into D reg
A=A-1 // Move to previous address in stack
D=M-D // Calculate diff between argument[x-1] and argument[x]
@IF_TRUE_{arithmetic_counter} // Set jump target
D;{jump_type} // Compare D and decide if we need to jump to IF_TRUE target
@{stack_pointer}
A=M-1 // Move to last active value in stack
M=0 // Set this memory cell to be False
@CONTINUE_{arithmetic_counter}
0;JMP
(IF_TRUE_{arithmetic_counter})
@{stack_pointer}
A=M-1 // Move to last active value in stack
M=-1 // Set this memory cell to be True
(CONTINUE_{arithmetic_counter})
",
            stack_pointer=STACK_POINTER,
            arithmetic_counter=self.arithmetic_counter,
            jump_type=jump_type
        );
        self.target_descriptor.write(&code.into_bytes());
        self.arithmetic_counter = self.arithmetic_counter + 1;
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
        segment.starts_with("this") || segment.starts_with("that") {
            let code = format!(
"@{index}
D=A // Save shift from base to D register
@{local_base}
D=D+M // Save shift + base_address to D register
A=D // Set memory to shift + base_address
D=M // Save content of memory to D register
@{stack_pointer} // Set address to stack_pointer
A=M // Move to cell, following pointer
M=D // Set content of this cell in stack to be conent of memory segment
@{stack_pointer}
M=M+1 // Bump stack_pointer, so it points to new empty memory cell
",
                index=index,
                local_base=MEMORY_SEGMENT_BASE.get::<str>(&segment).unwrap(),
                stack_pointer=STACK_POINTER
            );
            self.target_descriptor.write(&code.into_bytes());
        } else if segment.starts_with("temp") {
            let code = format!(
                "@{index}
D=A // Save shift from base to D register
@{local_base}
D=D+A // Save shift + base_address to D register
A=D // Set memory to shift + base_address
D=M // Save content of memory to D register
@{stack_pointer} // Set address to stack_pointer
A=M // Move to cell, following pointer
M=D // Set content of this cell in stack to be conent of memory segment
@{stack_pointer}
M=M+1 // Bump stack_pointer, so it points to new empty memory cell
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
    // TODO: There was an idea to rewrite this with one old trick
    // about swapping two unsigned int variables without tmp variable.
    // We can definitely avoid using R13 as tmp storage.
    pub fn write_pop(&mut self, raw : &String, segment : &String, index : &usize) {
        let helper_comment = format!("// {}\n", raw);
        self.target_descriptor.write(&helper_comment.into_bytes());

        if segment.starts_with("this") || segment.starts_with("that") ||
            segment.starts_with("local") || segment.starts_with("argument") {
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
            } else if segment.starts_with("temp") {
                // works for local segment
                let code = format!(
                    "@{index}
D=A // save shift from base to D register
@{local_base}
D=D+A // save shift + base_address to D register (SPECIAL CASE FOR TEMP SEGMENT)
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

    pub fn close(&mut self) {
        self.target_descriptor.write(
            &"(END)
             @END
             0;JMP
            ".to_string().into_bytes()
        );
    }
}
