// Recursive structure/implementation of Json

use std::collections::HashMap;

enum Json {
  Null,
  Boolean(bool),
  Number(f64),
  String(String),
  Array(Vec<Json>),
  Object(Box<HashMap<String, Json>>)
}
