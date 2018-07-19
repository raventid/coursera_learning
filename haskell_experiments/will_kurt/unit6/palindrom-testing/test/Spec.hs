import Data.Char (isPunctuation)

import Lib

assert :: Bool -> String -> String -> IO ()
assert test passStatement failStatement = if test
                                          then putStrLn passStatement
                                          else putStrLn failStatement

prop_punctuationInvariant text = preprocess text ==
                                  preprocess noPuncText
   where noPuncText = filter (not . isPunctuation) text

prop_reverseInvariant text = isPalindrome text == (isPalindrome (reverse text))

main :: IO ()
main = do
  putStrLn "Running tests..."
  assert (isPalindrom "racecar") "passed 'racecar'" "FAIL: 'racecar'"
  assert (isPalindrom "racecar!") "passed 'racecar!'" "FAIL: 'racecar!'"
  assert ((not . isPalindrom) "cat") "passed 'cat'" "FAIL: 'cat'"
  assert (isPalindrom "racecar.") "passed 'racecar.'" "FAIL: 'racecar.'"
  putStrLn "All tests finished."
