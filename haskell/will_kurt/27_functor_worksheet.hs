import qualified Data.Map as Map

-- Example without Functor
successfulRequest :: Maybe Int
successfulRequest = Just 6

failedRequest :: Maybe Int
failedRequest = Nothing

-- To might create a helper function Int -> Int
-- and pass it to incMaybe (it would be easier to change later)
-- But still the name is wrong then, why only inc?
-- An what if we wanna inc something in IO context?

-- A lot of questions and potentially redundant code.
incMaybe :: Maybe Int -> Maybe Int
incMaybe (Just n) = Just (n + 1)
incMaybe Nothing = Nothing

tryWithSuccessful = incMaybe successfulRequest
tryWithFailed = incMaybe failedRequest


-- Functor to the rescue!
-- fmap :: Functor f => (a -> b) -> f a -> f b

-- <$> is fmap synonim
tryWithSuccessfulFunctorVersion = (+ 1) <$> successfulRequest
tryWithFailedFunctorVersion = (+ 1) <$> failedRequest



-- Robot part application.
-- We'll design it right here.

data RobotPart = RobotPart {name :: String
                           , description :: String
                           , cost :: Double
                           , count :: Int} deriving Show

leftArm :: RobotPart
leftArm = RobotPart {name = "Left arm"
                    , description = "left arm for face punching!"
                    , cost = 1000.0
                    , count = 3}

rightArm :: RobotPart
rightArm = RobotPart {name = "Right arm"
                     , description = "right arm for kind gestures"
                     , cost = 1025.0
                     , count = 5}

robotHead :: RobotPart
robotHead = RobotPart {name = "Robot head"
                      , description = "this head looks mad"
                      , cost = 5092.25
                      , count = 2}

type Html = String

renderHtml :: RobotPart -> Html
renderHtml part = mconcat [ "<h2>", partName, "</h2>"
                          , "<p><h3>desc</h3>", partDesc
                          , "</p><p><h3>cost</h3>"
                          , partCost
                          , "</p><p><h3>count</h3>"
                          , partCount, "</p>"]
  where partName = name part
        partDesc = description part
        partCost = show $ cost part
        partCount = show $ count part

partsDb :: Map.Map Int RobotPart
partsDb = Map.fromList keyVals
  where keys = [1,2,3]
        vals = [leftArm, rightArm, robotHead]
        keyVals = zip keys vals


insertSnippet :: Maybe Html -> IO ()
insertSnippet  = undefined

partVal :: Maybe RobotPart
partVal = Map.lookup 1 partsDb

-- I can use fmap to apply (RobotPart -> Html) to Maybe RobotPart
-- and to get Maybe Html
partHtml :: Maybe Html
partHtml = renderHtml <$> partVal

-- Page with index of all parts
allParts :: [RobotPart]
allParts = map snd (Map.toList partsDb)

-- List's fmap has synonim - `map`
-- So for list -> map == fmap == <$>
allPartsHtml :: [Html]
allPartsHtml = renderHtml <$> allParts

htmlPartsDb :: Map.Map Int Html
htmlPartsDb = renderHtml <$> partsDb

-- The greatest thing about Functor is that you don't care
-- about concrete wrapper (like maybe)
leftArmIO :: IO RobotPart
leftArmIO = return leftArm


-- Some question:
data Box a = Box a deriving Show

instance Functor Box where
  fmap f (Box a) = Box (f a)

doubleInBox :: Box Int -> Box [Int]
doubleInBox box = double <$> box

double :: Int -> [Int]
double val = [val, val]

runDoublifier :: Box [Int]
runDoublifier = doubleInBox $ Box 10

wrapBox :: a -> Box a
wrapBox a = Box a

unwrapBox :: Box a -> a
unwrapBox (Box a) = a
