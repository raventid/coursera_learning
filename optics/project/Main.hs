{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Main where

import Control.Lens
import qualified Control.Lens.Unsound as U
import Control.Applicative
import Data.Char
import qualified Data.Map as M
import qualified Data.Set as S
import qualified Data.Text as T

data Ship = Ship {
  _name :: String
, _numCrew :: Int
} deriving (Show)

getNumCrew :: Ship -> Int
getNumCrew = _numCrew

setNumCrew :: Ship -> Int -> Ship
setNumCrew ship newNumCrew = ship{_numCrew = newNumCrew}

numCrew :: Lens' Ship Int
numCrew = lens getNumCrew setNumCrew

getName :: Ship -> String
getName = _name

setName :: Ship -> String -> Ship
setName ship newName = ship{_name = newName}

name :: Lens' Ship String
name = lens getName setName


data Wand = Wand deriving (Show)
data Book = Book deriving (Show)
data Potion = Potion deriving (Show)

data Inventory =
  Inventory {
    _wand :: Wand
  , _book :: Book
  , _potions :: [Potion]
  }

makeLenses ''Inventory

-- Now we can use our TH lenses with any combinator
-- view wand $ Inventory Wand Book [Potion]


-- Lens which fails first law (set-get)
type UserName = String
type UserId = String

data Session =
  Session { _userId :: UserId
          , _userName :: UserName
          , _createdTime :: String
          , _expiryTime :: String
          } deriving (Show, Eq)

makeLenses ''Session

userInfo :: Lens' Session (UserId, UserName)
userInfo = U.lensProduct userId userName

-- session = Session "USER-1234" "Joey Tribbiani" "2019-07-25" "2019-08-25"
-- view userInfo session

alongsideUserId :: Lens' Session (Session, UserId)
alongsideUserId = U.lensProduct id userId

-- session = Session "USER-1234" "Joey Tribbiani" "2019-07-25" "2019-08-25"
-- newSession = session{_userId="USER-5678"}
-- view alongsideUserId (set alongsideUserId (newSession, "USER-9999") session)
-- view alongsideUserId (set alongsideUserId (newSession, "USER-9999") session)

-- The problem here is that:
-- view alongsideUserId (set alongsideUserId (newSession, "USER-9999") session) == (newSession, "USER-9999")
-- I cannot completely agree with this (now), we do not get what we set in session field, but it is not a session lens. It is alongsideUseId lens, so why should it return "USER-9999" if it is not a session lens? Maybe from a formal point of view name of lens does not matter. You set some focus, and if you read this focus with the same lens you should see it (Makes sense!)
-- UPD: After rereading lens laws one more time, I think I feel alongsideUserId is breaking the lens laws.


-- To make another example about breaking lens
-- Imagine this structure:
data BadLensRec = BadLensRec { _blrVal :: Int } deriving (Show)

getVal :: BadLensRec -> Int
getVal = _blrVal

setVal :: BadLensRec -> Int -> BadLensRec
-- Rule number 2 violation:
-- *Main> set val (view val b) b
-- BadLensRec {_blrVal = 20}

-- Rule number 3 violation:
-- *Main> set val 30 (set val 20 b)
-- BadLensRec {_blrVal = 60}

-- I might easily violate law number 1 too with this lense, I can just add view of whole structure in getter.
setVal badLensRec newVal = badLensRec{_blrVal = (getVal badLensRec) + newVal}

val :: Lens' BadLensRec Int
val = lens getVal setVal

main :: IO ()
main = putStrLn "Stub main"
