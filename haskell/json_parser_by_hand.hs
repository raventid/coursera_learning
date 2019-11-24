module JsonParser where

data JsonValue =
    JNull
  | JBool Bool
  | JNumber Integer
  | JString String
  | JArray [JsonValue]
  | JObject [(String, JsonValue)] -- No Map in standard library ;)
  deriving (Show, Eq)

main :: IO ()
main = putStrLn "Placeholder"
