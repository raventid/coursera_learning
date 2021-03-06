import Control.Monad
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  let linesToRead = if length args > 0
                    then (read (head args)) :: Int
                    else 0 :: Int
  putStrLn ("Enter " ++ show linesToRead ++ " number:")
  numbers <- myReplicateM linesToRead getLine
  let vals = map read numbers :: [Int]
  print (sum vals)



-- Not the best place for this excersice, but anyway:

myReplicateM n action = mapM (\_ -> action) [1..n]
