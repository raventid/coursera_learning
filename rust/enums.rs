enum Pet {
  Cat,
  Dog,
  Mouse
}

use self::Pet::*;

enum HttpStatus {
  Ok = 200,
  NotModified = 304,
  NotFound = 404
}

use std::mem::size_of;

assert_eq!(size_of::<Pet>(), 1);
assert_eq!(size_of::<HttpStatus>(), 2);

assert_eq!(HttpStatus::Ok as i32, 200);

fn to_http_status(i: u32) -> Option<HttpStatus> {
  match i {
    200 => Some(HttpStatus::Ok),
    304 => Some(HttpStatus::NotModified),
    404 => Some(HttpStatus::NotFound),
    _ => None
  }
} 
