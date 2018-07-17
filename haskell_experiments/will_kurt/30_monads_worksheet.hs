import qualified Data.Map as Map

type UserName = String
type GamerId = Int
type PlayerCredits = Int

userNameDB :: Map.Map GamerId UserName
userNameDB = Map.fromList [(1,"nYarlathoTep")
                          ,(2,"KINGinYELLOW")
                          ,(3,"dagon1997")
                          ,(4,"rcarter1919")
                          ,(5,"xCTHULHUx")
                          ,(6,"yogSOThoth")]

creditsDB :: Map.Map UserName PlayerCredits
creditsDB = Map.fromList [("nYarlathoTep",2000)
                         ,("KINGinYELLOW",15000)
                         ,("dagon1997",300)
                         ,("rcarter1919",12)
                         ,("xCTHULHUx",50000)
                         ,("yogSOThoth",150000)]

lookupUserName :: GamerId -> Maybe UserName
lookupUserName id = Map.lookup id userNameDB

lookupCredits :: UserName -> Maybe PlayerCredits
lookupCredits username = Map.lookup username creditsDB

-- It works if I comment my type signature, but it just works the wrong way.
creditsFromId :: GamerId -> Maybe PlayerCredits -- It's join, actually.
creditsFromId id = lookupUserName id >>= lookupCredits

-- Monad bind is:
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b

-- Here I'm trying to force IO to avoid using `>>` operator (why not?)
echoVerbose' :: IO ()
echoVerbose' = second $ fmap id $ first
  where first = putStrLn "Enter a String an we'll echo it!"
        second _ = getLine >>= putStrLn

echoVerbose :: IO ()
echoVerbose = putStrLn "Enter a String and we'll echo it!" >> getLine >>= putStrLn


-- Example with tieing all this stuff together in beautiful programm
askForName :: IO ()
askForName = putStrLn "What is your name?"

nameStatement :: String -> String
nameStatement name = "Hello, " ++ name ++ "!"

mainProg :: IO String
mainProg = (askForName >> getLine) >>= (\name -> return (nameStatement name))
