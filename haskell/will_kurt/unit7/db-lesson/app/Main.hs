module Main where

import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Data.Time

data Tool = Tool
  { toolId :: Int
  , name :: String
  , description :: String
  , lastReturned :: Day
  , timesBorrowed :: Int
  }

data User = User
  { userId :: Int
  , userName :: String
  }

instance Show User where
    show user = mconcat [ show $ userId user
                        , ".)  "
                        , userName user]

instance Show Tool where
   show tool = mconcat [ show $ toolId tool
                       , ".) "
                       , name tool
                       , "\n description: "
                       , description tool
                       , "\n last returned: "
                       , show $ lastReturned tool
                       , "\n times borrowed: "
                       , show $ timesBorrowed tool
                       , "\n"]

-- class FromRow a where
--   fromRow :: RowParser a

instance FromRow User where
   fromRow = User <$> field
                  <*> field

instance FromRow Tool where
   fromRow = Tool <$> field
                  <*> field
                  <*> field
                  <*> field
                  <*> field

db :: String
db = "tools.db"

addUser :: String -> IO ()
addUser userName =
  withConn db $
  \conn -> do
    execute conn "INSERT INTO users (username) VALUES (?)" (Only userName)
    print "user added"

checkout :: Int -> Int -> IO ()
checkout userId toolId = withConn db $
                         \conn -> do
                           execute conn
                             "INSERT INTO checkedout (user_id,tool_id) VALUES (?,?)"
                             (userId,toolId)

withConn :: String -> (Connection -> IO ()) -> IO ()
withConn dbName action = do
  conn <- open dbName
  action conn
  close conn -- It's really important to close a connection.

-- Does not compile.
-- simpleExecutor :: String -> IO ()
-- simpleExecutor q = withConn db $
--              \conn ->  do
--                resp <- query_ conn q
--                mapM_ print resp


-- TODO: page 549. It just does not see the tables in my tools.db? OS X? Wrong code?
-- Need skill to debug Haskell code.
printUsers :: IO ()
printUsers = withConn db $
             \conn ->  do
               resp <- query_ conn "SELECT name FROM sqlite_master WHERE type='table';" :: IO [User]
               mapM_ print resp

main :: IO ()
main = print "db-lessonn"
