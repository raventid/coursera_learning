module DoNotation where

helloPerson :: String -> String
helloPerson name = "Hello" ++ " " ++ name ++ "!"

main :: IO ()
main = do
  putStrLn "Hello! What's your name?"
  name <- getLine
  let statement = helloPerson name
  putStrLn name


input :: Maybe String
input = Just "Raventid"

maybeMain :: Maybe String
maybeMain = do
  name <- input
  let greeting = helloPerson name
  return greeting
