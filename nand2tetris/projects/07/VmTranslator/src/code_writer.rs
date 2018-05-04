use std::io::{ BufReader, Error };
use std::io::prelude::*;
use std::result::Result;
use std::fs::File;

// Opens the output file, and gets ready to write into it
fn constructor(output_file : String) -> Result<(), Error> {
    let file = File::open(output_file)?;
    let buffer = BufReader::new(file);

    for line in buffer.lines() {
        println!("{}", line.unwrap());
    }

    Ok(())
}

// Writes to the file assembly code which represents current arithmetic command
fn write_arithmetic() {

}

// Writes assembly for push and pop commands
fn write_push_pop() {

}

// Just closes the file
fn close() {

}
