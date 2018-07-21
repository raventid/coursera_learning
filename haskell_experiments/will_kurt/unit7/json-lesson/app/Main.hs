module Main where

import Data.Aeson
import Data.Text as T
import Data.ByteString.Lazy as B
import Data.ByteString.Lazy.Char8 as BC
import Control.Monad
import GHC.Generics

sampleError :: BC.ByteString
sampleError = "{\"message\":\"oops!\",\"error\": 123}"

data ErrorMessage = ErrorMessage
                    { message :: T.Text
                    , errorCode :: Int
                    } deriving Show
-- (.:)
--   :: FromJSON a =>
--      Object -> Text -> aeson-1.3.1.1:Data.Aeson.Types.Internal.Parser a

instance FromJSON ErrorMessage where
   parseJSON (Object v) =
     ErrorMessage <$> v .: "message"
                  <*> v .: "error"

-- (.=) :: (KeyValue kv, ToJSON v) => Text -> v -> kv

instance ToJSON ErrorMessage where
  toJSON (ErrorMessage message errorCode) =
    object [ "message" .= message
           , "error" .= errorCode ]

sampleErrorDecoded :: BC.ByteString -> Either String ErrorMessage
sampleErrorDecoded json = eitherDecode json


-- That was a small sketch. Now - real work.
data NOAAResult = NOAAResult
                   { uid :: T.Text
                   , mindate :: T.Text
                   , maxdate :: T.Text
                   , name :: T.Text
                   , datacoverage :: Float
                   , resultId :: T.Text
                   } deriving Show

instance FromJSON NOAAResult where
   parseJSON (Object v) =
     NOAAResult <$> v .: "uid"
                <*> v .: "mindate"
                <*> v .: "maxdate"
                <*> v .: "name"
                <*> v .: "datacoverage"
                <*> v .: "id"


data Resultset = Resultset
                  { offset :: Int
                  , count :: Int
                  , limit :: Int
                  } deriving (Show, Generic)
instance FromJSON Resultset


data Metadata = Metadata
                {
                  resultset :: Resultset
                } deriving (Show, Generic)
instance FromJSON Metadata


data NOAAResponse = NOAAResponse
                    { metadata :: Metadata
                    , results :: [NOAAResult]
                    } deriving (Show, Generic)
instance FromJSON NOAAResponse

printResults :: Either String [NOAAResult] -> IO ()
printResults (Left error) = print error
printResults (Right results) = do
   forM_ results (print . name)
     -- print dataName

main :: IO ()
main = do
       jsonData <- B.readFile "app/data.json"
       let noaaResponse = eitherDecode jsonData :: Either String NOAAResponse
       let noaaResults = results <$> noaaResponse
       printResults noaaResults

