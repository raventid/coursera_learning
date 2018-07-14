import System.IO

main :: IO ()
main = do
  helloFile <- openFile "hello.txt" ReadMode

  hasLine <- fmap not (hIsEOF helloFile)
  firstLine <- if hasLine then hGetLine helloFile else return "empty"
  putStrLn firstLine

  hasSecondLine <- fmap not (hIsEOF helloFile)
  secondLine <- if hasSecondLine then hGetLine helloFile else return "empty"
  goodByeFile <- openFile "goodbye.txt" WriteMode
  hPutStrLn goodByeFile secondLine -- putStrLn btw is just a specialized hPutStrLn

  hClose helloFile -- hClose for handle close
  hClose goodByeFile

  putStrLn "done!"
