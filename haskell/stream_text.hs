-- Fast matcher, which finds the word in text stream (endless)
data Matcher = (Char -> String) | MatchFound (Int, Int)

makeTry :: String -> Matcher
makeTry [] = MatchFound (indexStart, indexEnd)
makeTry (n:needle) = \x -> if n == x then makeTry needle else makeTry n:needle

find :: Stream  -> MatchFound (Int, Int)
find (s:stream) = let try = makeTry "My word" in try s
