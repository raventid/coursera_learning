{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Main where

import Control.Lens
import Control.Lens.TH
-- import Control.Applicative
-- import Data.Char
-- import qualified Data.Map as M
-- import qualified Data.Set as S
-- import qualified Data.Text as T

-- data Ship = Ship {
--   _name :: String
-- , _numCrew :: Int
-- } deriving (Show)

-- getNumCrew :: Ship -> Int
-- getNumCrew = _numCrew

-- setNumCrew :: Ship -> Int -> Ship
-- setNumCrew ship newNumCrew = ship{_numCrew = newNumCrew}

-- numCrew :: Lens' Ship Int
-- numCrew = lens getNumCrew setNumCrew

-- getName :: Ship -> String
-- getName = _name

-- setName :: Ship -> String -> Ship
-- setName ship newName = ship{_name = newName}

-- name :: Lens' Ship String
-- name = lens getName setName


data Wand = Wand
data Book = Book
data Potion = Potion

data Inventory =
  Inventory {
    _wand :: Wand
  , _book :: Book
  , _potions :: [Potion]
  }

makeLenses ''Inventory


main :: IO ()
main = putStrLn "Stub main"
