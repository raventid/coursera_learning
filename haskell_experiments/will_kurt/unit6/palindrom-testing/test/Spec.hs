import Lib

assert :: Bool -> String -> String -> IO ()
assert test passStatement failStatement = if test
                                          then putStrLn passStatement
                                          else putStrLn failStatement

main :: IO ()
main = do
  putStrLn "Running tests..."
  assert (isPalindrom "racecar") "passed 'racecar'" "FAIL: 'racecar'"
  assert (isPalindrom "racecar!") "passed 'racecar!'" "FAIL: 'racecar!'"
  assert ((not . isPalindrom) "cat") "passed 'cat'" "FAIL: 'cat'"
  assert (isPalindrom "racecar.") "passed 'racecar.'" "FAIL: 'racecar.'"
  putStrLn "All tests finished."
