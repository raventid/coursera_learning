module Ch3Ex where

-- thirdLetter :: String -> Char
-- thirdLetter x = head (drop 2 x)
-- 
-- letterIndex :: Int -> Char
-- letterIndex x = drop (x-1) 

rvrs :: String -> String
rvrs x = concat [(drop 9 x), " is ", (take 5 x)] 

main :: IO ()
main = print (rvrs "Curry is awesome")
