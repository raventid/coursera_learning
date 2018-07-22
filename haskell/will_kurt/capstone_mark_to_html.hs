{-# LANGUAGE OverloadedStrings #-}

-- WARNING!!!
-- To work with this example download some .mrc sample
-- It's easy to find one in the internet. I'll attach a link here.

import qualified Data.ByteString as B
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Text.Encoding as E
import Data.Maybe

type Author = T.Text
type Title = T.Text
type Html = T.Text

-- MARC format types
type MarcRecordRaw = B.ByteString
type MarcLeaderRaw = B.ByteString
type MarcDirectoryRaw = B.ByteString

data Book = Book
  { author :: Author
  , title :: Title
  } deriving Show

-- MARC parsing
leaderLength :: Int
leaderLength = 24

getLeader :: MarcRecordRaw -> MarcLeaderRaw
getLeader record = B.take leaderLength record

getRecordLength :: MarcLeaderRaw -> Int
getRecordLength leader = rawToInt (B.take 5 leader)

nextAndRest :: B.ByteString -> (MarcRecordRaw, B.ByteString)
nextAndRest marcStream = B.splitAt recordLength marcStream
  where recordLength = getRecordLength marcStream

allRecords :: B.ByteString -> [MarcRecordRaw]
allRecords marcStream = if marcStream == B.empty
                        then []
                        else next : allRecords rest
  where (next, rest) = nextAndRest marcStream

-- Determine the size of a directory
getBaseAddress :: MarcLeaderRaw -> Int
getBaseAddress leader = rawToInt (B.take 5 remainder)
  where remainder = B.drop 12 leader

getDirectoryLength :: MarcLeaderRaw -> Int
getDirectoryLength leader = getBaseAddress leader - (leaderLength - 1)

getDirectory :: MarcRecordRaw -> MarcDirectoryRaw
getDirectory record = B.take directoryLength afterLeader
  where directoryLength = getDirectoryLength record
        afterLeader = B.drop leaderLength record

-- Helper functions
rawToInt :: B.ByteString -> Int
rawToInt = read . T.unpack . E.decodeUtf8

-- page 327 typo
booksToHtml :: [Book] -> Html
booksToHtml books = mconcat [ "<html>\n"
                            , "<head><title>books</title>"
                            , "<meta charset='utf-8'/>"
                            , "</head>\n" -- typo is here
                            , "<body>\n"
                            , booksHtml
                            , "\n</body>\n"
                            , "</html>"]
  where booksHtml = (mconcat . (map bookToHtml)) books

bookToHtml :: Book -> Html
bookToHtml book = mconcat [ "<p>\n"
                          , titleInTags
                          , authorInTags
                          , "</p>\n"]
  where titleInTags = mconcat ["<strong>", (title book), "</strong>\n"]
        authorInTags = mconcat ["<em>", (author book), "</em>\n"]

-- Test data
book1 :: Book
book1 = Book {
      title = "The Conspiracy Against the Human Race"
    , author = "Ligotti, Thomas"
    }

book2 :: Book
book2 = Book {
      title = "A short story of Haskell"
    , author = "Brant, Kyle"
    }

book3 :: Book
book3 = Book {
      title = "Coq cookbook"
    , author = "Ante, Julian"
    }

myBooks :: [Book]
myBooks = [book1, book2, book3]
-- Test data END

main :: IO ()
main = do
  marcData <- B.readFile "sample.mrc"
  let marcRecords = allRecords marcData
  print (length marcRecords)
