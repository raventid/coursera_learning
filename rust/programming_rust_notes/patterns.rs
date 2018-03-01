// Some nice tips about refutable patterns outside of pattern matching expressions

fn main() {
  // ...handle just one enum variant specially
  if let RoughTime::InTheFuture(_, _) = user.date_of_birth() { user.set_time_traveler(true); }

  // ...run some code only if a table lookup succeeds
  if let Some(document) = cache_map.get(&id) { return send_cached_response(document); }

  // ...repeatedly try something until it succeeds
  while let Err(err) = present_cheesy_anti_robot_task() { log_robot_attempt(err);
    // let the user try again (it might still be a human)
  }

  // ...manually loop over an iterator
  while let Some(_) = lines.peek() {
      read_paragraph(&mut lines);
  }
}
