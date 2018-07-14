main :: IO ()
main = do
  input <- getContents
  mapM_ putStrLn (lookupQuote $ lines input)


quotes = ["It's good idea!",
          "We failed",
          "Classical Rails stack",
          "With classes or with methods",
          "I know every programming language"]

-- Have to use right folding here.
-- Left folding waiting for the end of `input` list, which is infinite, oops.
lookupQuote :: [String] -> [String]
lookupQuote ("n" : xs) = []
lookupQuote xs = foldr (\index allQuotes -> (quotes !! (read index - 1)):allQuotes) [] xs
