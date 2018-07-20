module Main where

import Data.Aeson
import Data.Text as T
import Data.ByteString.Lazy as B
import Data.ByteString.Lazy.Char8 as BC
import GHC.Generics

sampleError :: BC.ByteString
sampleError = "{\"message\":\"oops!\",\"error\": 123}"

data ErrorMessage = ErrorMessage
                    { message :: T.Text
                    , errorCode :: Int
                    } deriving Show

instance FromJSON ErrorMessage where
   parseJSON (Object v) =
     ErrorMessage <$> v .: "message"
                  <*> v .: "error"

instance ToJSON ErrorMessage where
  toJSON (ErrorMessage message errorCode) =
    object [ "message" .= message
           , "error" .= errorCode ]

sampleErrorDecoded :: BC.ByteString -> Maybe ErrorMessage
sampleErrorDecoded json = decode json

main :: IO ()
main = print "hi"
