module SixSix where
  assignToGroups n aList = zip groups aList
    where groups = cycle [1..n]

  run = putStrLn $ show $ assignToGroups 3 ["file1.txt", "file2.txt", "file3.txt", "file4.txt", "file5.txt", "file6.txt"]
