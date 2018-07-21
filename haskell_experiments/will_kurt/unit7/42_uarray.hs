import Data.Array.Unboxed

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
