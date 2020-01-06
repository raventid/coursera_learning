module ArrowMap46 where

import Prelude hiding (lookup)
import qualified Data.List as L

class MapLike m where
    empty :: m k v
    lookup :: Ord k => k -> m k v -> Maybe v
    insert :: Ord k => k -> v -> m k v -> m k v
    delete :: Ord k => k -> m k v -> m k v
    fromList :: Ord k => [(k,v)] -> m k v

newtype ArrowMap k v = ArrowMap { getArrowMap :: k -> Maybe v }


instance MapLike ArrowMap where
  empty = ArrowMap (\_ -> Nothing)
  lookup k (ArrowMap f) = f k
  insert k v (ArrowMap f) = ArrowMap ( \k' -> if k' == k then Just v else f k' )
  delete k (ArrowMap f) = ArrowMap ( \k' -> if k' == k then Nothing else f k' )
  fromList [] = empty
  fromList xs = foldr (\(k,v) m -> insert k v m) empty xs
