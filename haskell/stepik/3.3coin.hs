import Data.List

-- system code
coins :: (Ord a, Num a) => [a]
coins = [2,3,7]

change :: (Ord a, Num a) => a -> [[a]]
change 0 = [[]]
change value = [coin:coinCombinations | coin <- coins, coin <= value, coinCombinations <- (change (value - coin))]

-- change :: (Ord a, Num a) => a -> [[a]]
-- change 0 = [[]]
-- change s = [coin:ch | coin <- coins, coin <= s, ch <- (change $ s - coin)]

main :: IO ()
main = putStrLn "main"

evenOnly :: [a] -> [a]
evenOnly = snd . foldr (\x ~(stream1, stream2) -> (x:stream2, stream1) ) ([], [])

revRange :: (Char, Char) -> [Char]
revRange = unfoldr g
  where g (start, end) |  start > end = Nothing
                       |  otherwise = Just (end, (start, pred end))
