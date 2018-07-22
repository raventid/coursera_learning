module XorBool where

xorBool :: Bool -> Bool -> Bool
xorBool left right = (left || right) && (not (left && right))

xorPair :: (Bool, Bool) -> Bool
xorPair (x, y) = xorBool x y

xor :: [Bool] -> [Bool] -> [Bool]
xor xs ys = map xorPair (zip xs ys)

type Bits = [Bool]

intToBits' :: Int -> Bits
intToBits' 0 = [False]
intToBits' 1 = [True]
intToBits' n = if remainder == 0
              then False : intToBits' nextVal
              else True : intToBits' nextVal
  where
    remainder = n `mod` 2
    nextVal = n `div` 2

maxBits :: Int
maxBits = length (intToBits' maxBound)

intToBits :: Int -> Bits
intToBits n = leadingFalses ++ reversedBits
  where reversedBits = reverse (intToBits' n)
        missingBits = maxBits - (length reversedBits)
        leadingFalses = take missingBits (cycle [False])

charToBits :: Char -> Bits
charToBits char = intToBits (fromEnum char)


-- To understand this,
-- it’s helpful to realize that
-- binary 101 in decimal is 1*2^2 + 0*2^1 + 1*2^0.

-- Because the only two values are 1 or 0,
-- you take the sum of those nonzero powers.

-- indices thing works like this:
-- [9,8..0] = [9,8,7,6,5,4,3,2,1,0]
bitsToInt :: Bits -> Int
bitsToInt bits = sum (map (\x -> 2^(snd x)) trueLocations)
  where size = length bits
        indices = [size-1, size-2 .. 0]
        trueLocations = filter (\x -> fst x == True) (zip bits indices)

bitsToChars :: Bits -> Char
bitsToChars bits = toEnum (bitsToInt bits)

myPad :: String
myPad = "MY_SUPER_KEY_YOU_WILL_NEVER_KNOW"

myPlainText :: String
myPlainText = "My plain text you will never decipher"

applyOTP' :: String -> String -> [Bits]
applyOTP' pad text = map (\pair -> (fst pair) `xor` (snd pair)) (zip padBits textBits)
  where padBits = map charToBits pad
        textBits = map charToBits text


-- If we apply this function to the function to short pad and long text
-- we'll get a shorten pad, which is very bad or should I say inacceptable.
applyOTP :: String -> String -> String
applyOTP pad text = map bitsToChars bitList
  where bitList = applyOTP' pad text


-- Let's wrap everything in typeclass
class Cipher a where
  encode :: a -> String -> String
  decode :: a -> String -> String


-- OneTimePad cipher
data OneTimePad = OTP String

instance Cipher OneTimePad where
  encode (OTP pad) text = applyOTP pad text
  decode (OTP pad) text = applyOTP pad text

myOTP :: OneTimePad
myOTP = OTP (cycle [minBound .. maxBound])

-- Linear congruential generator
-- https://en.wikipedia.org/wiki/Linear_congruential_generator
prng :: Int -> Int -> Int -> Int -> Int
prng a b maxNumber seed = (a * seed + b) `mod` maxNumber

samplePRNG :: Int -> Int
samplePRNG = prng 1337 7 100


-- StreamCipher, using lcg algo
data StreamCipher = StreamCipher

-- instance Cipher StreamCipher where
--   encode StreamCipher text = applySSP text
--   decode StreamCipher text = applySSP text

streamInts :: [Int]
streamInts = map samplePRNG [0 .. maxBound]

applySSP' :: String -> [Bits]
applySSP' target = map (\pair -> (fst pair) `xor` (snd pair)) (zip pad text)
  where pad = map intToBits streamInts
        text = map charToBits target

applySSP :: String -> String
applySSP target = map bitsToChars bitList
  where bitList = applySSP' target
