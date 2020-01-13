-- FWIW
{-
    maxBool = True
    minBool = False
    maxInt = 9223372036854775807
    minInt = (-9223372036854775808)
    maxChar = '\1114111'
    minChar = '\NUL'
-}

class (Eq a, Enum a, Bounded a) => SafeEnum a where
    ssucc :: a -> a
    ssucc val
        | val == maxBound = minBound
        | otherwise       = succ val
    spred :: a -> a
    spred val
        | val == minBound = maxBound
        | otherwise       = pred val

-- Perhaps this is better notation
class (Eq a, Enum a, Bounded a) => SafeEnum' a where
    ssucc' :: a -> a
    ssucc' val = if val == maxBound then minBound else succ val
    spred' :: a -> a
    spred' val = if val == minBound then maxBound else pred val


instance SafeEnum Bool

instance SafeEnum Int

instance SafeEnum Char
