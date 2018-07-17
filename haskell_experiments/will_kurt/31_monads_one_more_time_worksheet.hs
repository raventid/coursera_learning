helloPerson :: String -> String
helloPerson name = "Hello, " ++ name ++ "!"

mainDo :: IO ()
mainDo = do
  name <- getLine
  let statement = helloPerson name
  putStrLn statement

-- My vision
mainBind :: IO ()
mainBind = getLine >>= (\name -> return (helloPerson name)) >>= putStrLn

-- Official vision? Or just approximation by Will Kurt?
mainAnother :: IO ()
mainAnother = getLine >>= (\name -> (\statement -> putStrLn statement) (helloPerson name))
