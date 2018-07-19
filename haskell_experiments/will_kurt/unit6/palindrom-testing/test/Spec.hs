import Data.Char (isPunctuation)
import Test.QuickCheck

import Lib

prop_punctuationInvariant text = preprocess text ==
                                  preprocess noPuncText
   where noPuncText = filter (not . isPunctuation) text

prop_reverseInvariant text = isPalindrom text == (isPalindrom (reverse text))

main :: IO ()
main = do
  quickCheck prop_punctuationInvariant
  putStrLn "All tests passed."
