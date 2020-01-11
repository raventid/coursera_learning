module Reader56 where

-- Reader monad
safeHead = do
 b <- null
 if b
 then return Nothing
    else do
 h <- head
 return $ Just h

-- Maybe monad
safeHead' lst = do
    b <- Just (null lst)
    if b
    then Nothing
    else do
        h <- Just (head lst)
        return h



-- Desugaring of Reader monad
safeHead'' = null >>= \b -> if b then return Nothing else do h <- head; return $ Just h

-- remove embed `do`
safeHead''' = null >>= \b -> if b then return Nothing else head >>= \h -> return $ Just h

-- desugar return
safeHead'''' = null >>= \b -> if b then ((\x -> \e -> x) Nothing) else do head >>= \h -> (\x -> \e -> x) $ Just h

-- TODO: swap both >>= with function application

myFunc = return 2 >>= (+) >>= (*)


-- return == (\x -> \e -> x)
-- >>= :: (e -> a) -> (a -> e -> b) -> e -> b
-- m >>= k = \e -> k (m e) e


myFunc1 = (\x -> \e -> x) 2 >>= (+) >>= (*)
-- myFunc2 = (\2 -> \e -> 2) >>= (+) >>= (*)
myFunc3 = (\e -> 2) >>= (+) >>= (*)
myFunc4 = (\e' -> (+) ((\e -> 2) e') e') >>= (*)
myFunc5 = \e'' -> (*) ((\e' -> (+) ((\e -> 2) e') e') e'') e''


data Reader r a = Reader { runReader :: (r -> a) }

instance Functor (Reader r) where
  fmap = undefined

instance Applicative (Reader r) where
  pure = undefined
  x <*> y = undefined

instance Monad (Reader r) where
  return x = Reader $ \_ -> x
  m >>= k  = Reader $ \r -> runReader (k (runReader m r)) r

asks = Reader

local' :: (r -> r') -> Reader r' a -> Reader r a
local' f m = Reader $ \e -> runReader m ( f e )


type User = String
type Password = String
type UsersTable = [(User, Password)]

usersWithBadPasswords :: Reader UsersTable [User]
usersWithBadPasswords = asks (map fst . filter f)
  where f (name, password) = password == "123456"




doit :: Word -> IO ()
doit int = putStrLn . show $ int

unwrap value = do
  internal <- value
  return ()
