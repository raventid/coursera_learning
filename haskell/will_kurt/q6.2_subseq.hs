module SubSeq where

subseq :: Int -> Int -> [a] -> [a]
subseq start end list =
  let amount = end - start
      preparedList = drop start list
  in
  take amount preparedList

-- GHCi> subseq 2 5 [1 .. 10]
--  [3,4,5]
-- GHCi> subseq 2 7 "a puppy"
--  "puppy"
