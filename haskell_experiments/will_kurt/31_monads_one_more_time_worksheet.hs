helloPerson :: String -> String
helloPerson name = "Hello, " ++ name ++ "!"

mainDo :: IO ()
mainDo = do
  name <- getLine
  let statement = helloPerson name
  putStrLn statement

mainBind :: IO ()
mainBind = getLine >>= (\name -> return (helloPerson name)) >>= putStrLn
