import Data.Array.Unboxed
import Data.STRef
import Data.Array.ST
import Control.Monad
import Control.Monad.ST

zeroIndexArray :: UArray Int Bool
zeroIndexArray = array (0,9) [(3,True)]

oneIndexArray :: UArray Int Bool
oneIndexArray = array (1,10) $ zip [1 .. 10] $ cycle [True]

beansInBucket :: UArray Int Int
beansInBucket = array (0,3) [] -- Initialized to zeros by default

updateBiB :: UArray Int Int
updateBiB = beansInBucket // [(1,5), (3,6)]

addTwoToEachElement :: UArray Int Int
addTwoToEachElement = accum (+) updateBiB $ zip [0 .. 3] $ cycle [2]

doubleEachElement :: UArray Int Int
doubleEachElement = accum (*) addTwoToEachElement $ zip [0 .. 3] $ cycle [2]

listToSTUArray :: [Int] -> ST s (STUArray s Int Int)
listToSTUArray vals = do
  let end = length vals - 1
  stArray <- newArray (0, end) 0
  forM_ [0 .. end] $ \i -> do
    let val = vals !! i
    writeArray stArray i val
  return stArray

listToUArray :: [Int] -> UArray Int Int
listToUArray vals = runSTUArray $ listToSTUArray vals

swapST :: (Int,Int) -> (Int,Int)
swapST (x, y) = runST $ do
   x' <- newSTRef x
   y' <- newSTRef y
   writeSTRef x' y
   writeSTRef y' x
   xfinal <- readSTRef x'
   yfinal <- readSTRef y'
   return (xfinal, yfinal)

-- Highest form of Haskell
-- Buble sort on stateful array
myData :: UArray Int Int
myData = listArray (0,5) [7,6,4,8,10,2]

bubbleSort :: UArray Int Int -> UArray Int Int
bubbleSort myArray = runSTUArray $ do
  stArray <- thaw myArray
  let end = (snd . bounds) myArray
  forM_ [1 .. end] $ \i -> do
    forM_ [0 .. (end-1)] $ \j -> do
      val <- readArray stArray j
      nextVal <- readArray stArray (j+1)
      let outOfOrder = val > nextVal
      when outOfOrder $ do
        writeArray stArray j nextVal
        writeArray stArray (j+1) val
  return stArray

dataForCrossover :: (UArray Int Int, UArray Int Int)
dataForCrossover = (listToUArray [1,1,1,1,1], listToUArray [0,0,0,0,0])

-- crossover :: (UArray Int Int, UArray Int Int) -> Int -> UArray Int Int
-- crossover (l, r) pivot = runSTUArray $ do
--   firstArray <- thaw l
--   secondArray <- thaw r -- TODO: type error I cannot understand, so much left to learn!

--   let end = (snd . bounds) r -- but could be l, does not matter
--   forM_ [0 .. (end-1)] $ \i -> do
--     valR <- readArray firstArray i
--     valL <- readArray secondArray i

--     let takeFirst = i <= pivot
--     if takeFirst then writeArray firstArray i valR else writeArray firstArray i valL

--   return firstArray

crossover :: (UArray Int Int ,UArray Int Int) -> Int -> UArray Int Int
crossover (l,r) pivot = runSTUArray $ do
  arr <- thaw l
  let end = (snd . bounds) l
  forM_ [pivot .. end] $ \i -> do
    writeArray arr i $ r ! i
  return arr
