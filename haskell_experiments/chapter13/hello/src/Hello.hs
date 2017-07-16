module Hello (sayHello) where

sayHello :: String -> IO ()
sayHello word = do
  putStrLn ("Hello " ++ word ++ "!")
