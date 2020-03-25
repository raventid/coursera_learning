Js.log("Hello, BuckleScript and Reason!");
Js.log("Hello, my friend!");


// Let's get to types!
type schoolPerson = Teacher | Director | Student(string);

let greeting = person =>
  switch (person) {
  | Teacher => "Hey Professor!"
  | Director => "Hello Director."
  | Student("Richard") => "Still here Ricky?"
  | Student(anyOtherName) => "Hey, " ++ anyOtherName ++ "."
  };

let f = fun
  | Some(_) => "Hey"
  | None => "None";
