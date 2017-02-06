module Print3Broken where

printSecond :: IO ()
printSecond = do 
  putStrLn greeting
  where greeting = "Yarrrrf"

main :: IO ()
main = do
  putStrLn greeting
  printSecond
  where greeting = "Yarrrrr"
