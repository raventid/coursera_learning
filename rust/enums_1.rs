// Delay TimeUnit realisation
#[derive(Copy,Clone,Debug,PartialEq)]
enum RoughTime {
  InThePast(TimeUnit, u32),
  JustNow,
  InTheFuture(TimeUnit, u32) 
}

let four_score_and_seven_years_ago = RoughTime::InThePast(TimeUnit::Years, 4*20 + 7);
let three_hours_from_now = RoughTime::InThePast(TimeUnit::Hours, 3);


