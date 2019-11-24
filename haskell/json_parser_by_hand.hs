module JsonParser where

data JsonValue =
    JNull
  | JBool Bool
  | JNumber Integer
  | JString String
  | JArray [JsonValue]
  | JObject [(String, JsonValue)] -- No Map in standard library ;)
  deriving (Show, Eq)

newtype Parser a = Parser
  { runParser :: String -> Maybe (String, a) }

characterParser :: Char -> Parser Char
characterParser c = Parser $ \input ->
  case input of
    y : ys | y == c -> Just (ys, y)
    [] -> Nothing

jNull :: Parser JsonValue
jNull = undefined

main :: IO ()
main = putStrLn "Placeholder"
