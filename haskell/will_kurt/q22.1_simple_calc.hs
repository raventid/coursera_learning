import Data.List.Split

main :: IO ()
main = do
  input <- getContents
  let results = map calculate (lines input)
  print results

data Expr =
    Mult Int Int
  | Sum Int Int

calculate :: String -> Int
calculate = eval . parse

parse :: String -> Expr
parse eq
  | isPlus eq = Sum (fst sumArgs) (snd sumArgs)
  | isMult eq = Mult (fst mulArgs) (snd mulArgs)
  where
    toTuple args = ((read $ head args), (read $ last args))
    isPlus = elem '+'
    isMult = elem '*'
    sumArgs = toTuple $ splitOn "+" eq
    mulArgs = toTuple $ splitOn "*" eq

eval :: Expr -> Int
eval (Mult a b) = a * b
eval (Sum a b) = a + b
