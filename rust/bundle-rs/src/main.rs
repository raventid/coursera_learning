fn main() {
    println!("Hello, world!");
    // 1) Get current project address from command line // easy



    // 2) Run cargo vendor to obtain all open source dependencies of a project
    // The problem is the next one. Cargo vendor load project dependencies into vendor
    // directory. BUT this dependencies have their own dependencies, which makes it
    // more difficult. Should I run cargo vendor recursively and then build a tree?
    // Maybe I can precompile them in some plain file and send with main? Not sure.





    // 3) port extern crates to local folders
    // Cargo vendor already does it. We might merge step 2 and 3.








    // 4) build AMT(abstract module tree) of project with saved (AST|FORMATTED STRINGS|RAW STRINGS) (( THE MOST DIFFICULT PART /: ))
    // List of transformation rules:
    // - macro_use







    // 5) create TARGET_NAME file and using abstract module tree rebuild everything in one file.
    // After performing all of the transformations on AMT it should be trivial. Just writer text to the file.





    // Additions:
    // 1) Some course graders may require multiple files to be submitted. It might be a feature request.
    // 2) It might be a bit heavy to handle all project in memory, so we might want to implement some kind of streaming or persisitence.
}
