import System.Environment

getCounts :: String -> (Int, Int, Int)
getCounts input = (charCount, wordCount, lineCount)
  where charCount = length input
        wordCount = (length . words) input
        lineCount = (length . lines) input

countsText :: (Int, Int, Int) -> String
countsText (cc, wc, lc) = unwords [ "chars:"
                                  , show cc
                                  , "words:"
                                  , show wc
                                  , "lines:"
                                  , show lc
                                  ]

-- Cool note about readFile.
-- It does not close file descriptor.
-- Yeap, sounds scary and stupid, but
-- if you think about your IO being lazy
-- you might guess that if you perform
-- close file descriptor IO action right in read file
-- it MIGHT BE CLOSED BEFORE YOU'VE READ THE CONTENT OF A FILE!

-- Lazy! Make me crazy!
-- Yeap, you have to force Haskell to read the content
-- of file. it happens in the end of main.

main :: IO ()
main = do
  args <- getArgs
  let fileName = head args
  input <- readFile fileName
  let summary = (countsText . getCounts) input
  appendFile "stats.dat" (mconcat [fileName, " ", summary, "\n"])
