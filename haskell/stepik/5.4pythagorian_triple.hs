module PythagorianTriple54 where

pythagoreanTriple :: Int -> [(Int, Int, Int)]
pythagoreanTriple x = if x <= 0 then [] else do
  a <- [1..x]
  b <- [1..x]
  c <- [1..x]
  let a' = a^3
  let b' = b^2
  let c' = c^2
  if a < b && (a' + b' == c') then "_" else []
  return (a,b,c)


main' :: IO ()
main' = do
  putStrLn "What is your name?"
  putStr "Name: "
  name <- getLine
  case name of
    [] -> main'
    _ -> putStrLn $ "Hi, " ++ name
