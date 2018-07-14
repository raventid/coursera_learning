import Data.List.Split

main :: IO ()
main = do
  userInput <- getContents
  let numbers = toInts userInput
  print (sum numbers)

toInts :: String -> [Int]
toInts = map read . lines

