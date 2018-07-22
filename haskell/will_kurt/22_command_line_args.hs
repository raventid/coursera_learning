-- I didn't wrap this in module because it will make
-- GHC linking possible without a headache.
import System.Environment

-- General notes:
-- map - works with lists
-- mapM - (M for Monad) maps in context of monad
-- mapM_ - maps in context of monad and ignore return value

-- Underscore after the function name is smth like convention for
-- ignoring the return value.
main :: IO ()
main = do
  args <- getArgs
  mapM_ putStrLn args

qc221 :: IO ()
qc221 = do
  vals <- mapM (\_ -> getLine) [1,2,3]
  mapM_ putStrLn vals
