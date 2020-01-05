module MapLike46 where

import Prelude hiding (lookup)
import qualified Data.List as L
import Data.Function

class MapLike m where
    empty :: m k v
    lookup :: Ord k => k -> m k v -> Maybe v
    insert :: Ord k => k -> v -> m k v -> m k v
    delete :: Ord k => k -> m k v -> m k v
    fromList :: Ord k => [(k,v)] -> m k v
    fromList [] = empty
    fromList ((k,v):xs) = insert k v (fromList xs)

newtype ListMap k v = ListMap { getListMap :: [(k,v)] }
    deriving (Eq,Show)

instance MapLike ListMap where
    empty = ListMap []
    lookup  k (ListMap map) = case L.find (\(key, val) -> key == k) map of
                                Just (key, value) -> Just value
                                Nothing -> Nothing
    insert k v (ListMap map) = ListMap $ (k,v):(delete' k map)
    delete k (ListMap map) = ListMap $ delete' k map
    fromList map = ListMap map
    fromList [] = empty
    fromList ((k,v):xs) = insert k v (fromList xs)

delete' k map = L.deleteBy ((==) `on` fst) (k, undefined) map
