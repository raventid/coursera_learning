// All available command types for virtual machine
#[derive(Debug)]
pub enum Command {
    C_ARITHMETIC { raw: String, opcode: String },
    C_PUSH { raw: String, segment: String, index: usize },
    C_POP { raw: String, segment: String, index: usize },
    C_LABEL,
    C_GOTO,
    C_IF,
    C_FUNCTION,
    C_RETURN,
    C_CALL,
}
