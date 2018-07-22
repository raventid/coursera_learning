import Data.Text as T
import Data.Char (isPunctuation)
import Test.QuickCheck
import Test.QuickCheck.Instances

import Lib

prop_punctuationInvariant text = preprocess text == preprocess noPuncText
   where noPuncText = T.filter (not . isPunctuation) text

prop_reverseInvariant text = isPalindrom text == (isPalindrom (T.reverse text))

prop_caseInsensitiveInvariant text = isPalindrom text == (isPalindrom (T.toUpper text))

main :: IO ()
main = do
  quickCheck prop_punctuationInvariant
  quickCheckWith stdArgs { maxSuccess = 1000 } prop_reverseInvariant
  quickCheck prop_caseInsensitiveInvariant
  putStrLn "All tests passed."
