module Lib
    ( isPalindrom
      , preprocess
    ) where

import Data.Text as T
import Data.Char (isPunctuation)

preprocess :: T.Text -> T.Text
preprocess text = T.filter (not . isPunctuation) text

isPalindrom :: T.Text -> Bool
isPalindrom text = cleanText == T.reverse cleanText
  where cleanText = preprocess text
