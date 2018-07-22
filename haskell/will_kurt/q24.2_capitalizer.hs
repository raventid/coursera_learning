import System.Environment
import qualified Data.Text as T
import qualified Data.Text.IO as TI


capitalizeText :: T.Text -> T.Text
capitalizeText fullText = T.toUpper fullText

main :: IO ()
main = do
  args <- getArgs
  let sourceFile = head args
  let targetFile = head (tail args) -- I'm expecting two args. Toy program ^_^
  content <- TI.readFile sourceFile
  TI.writeFile targetFile (capitalizeText content)
