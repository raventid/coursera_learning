import System.Directory
import Data.List as L

main' :: IO ()
main' = do
   putStr "Substring: "
   query <- getLine
   if null query
   then putStrLn "Canceled"
   else do
          filepaths <- getDirectoryContents "."
          sequence_ $ map (removeFile' query) filepaths
          return ()

removeFile' :: String -> FilePath -> IO ()
removeFile' query filepath = do
   if L.isInfixOf query filepath
   then do
     removeFile filepath
     putStrLn $ "Removing file: " ++ filepath
   else return ()
