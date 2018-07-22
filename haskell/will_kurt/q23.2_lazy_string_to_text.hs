{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as TIO
import qualified Data.Text.Lazy.Read as TR
import Data.Text.Lazy.Builder as TB
import Data.Text.Lazy.Builder.Int as TBI
import Data.Either.Extra
import Data.Semigroup

toInts :: T.Text -> [Int]
toInts text = map (fst . fromRight' . TR.decimal) $ T.lines text

toText :: Int -> T.Text
toText n = (TB.toLazyText . TBI.decimal) n

main :: IO ()
main = do
   userInput <- TIO.getContents
   let numbers = toInts userInput
   TIO.putStrLn (toText $ sum numbers)
