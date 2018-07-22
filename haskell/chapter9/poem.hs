module Poem where

firstSen = "Tyger Tyger, burning bright\n"
secondSen = "In the forests of the night\n"
thirdSen = "What immortal hand or eye\n"
fourthSen = "Could frame thy fearful symmetry?"
sentences = firstSen ++ secondSen
           ++ thirdSen ++ fourthSen

myLines :: String -> [String]
myLines "" = []
myLines s = (takeWhile f s) : (myLines $ drop 1 $ dropWhile f s)
  where f = (/='\n')

split' :: String -> (Char -> Bool) -> [String]
split' "" f = []
split' s f = takeWhile f s : split' (drop 1 $ dropWhile f s ) f

myLines' :: String -> [String]
myLines' s = split' s (/='\n')

shouldEqual =
 [ "Tyger Tyger, burning bright"
  , "In the forests of the night"
  , "What immortal hand or eye"
  , "Could frame thy fearful symmetry?"
 ]

main :: IO ()
main =
   print $ "Are they equal? " ++ show (myLines' sentences == shouldEqual)
