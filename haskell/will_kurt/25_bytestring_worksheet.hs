{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

sampleBytes :: B.ByteString
sampleBytes = "Hello!" -- OverloadedStrings work with any string type!

bcInt :: B.ByteString
bcInt = "6"

convertToString :: B.ByteString -> String
convertToString bytes = BC.unpack bytes

convertToInt :: B.ByteString -> Int
convertToInt = read . convertToString
