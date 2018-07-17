import qualified Data.Map as Map

helloPerson :: String -> String
helloPerson name = "Hello, " ++ name ++ "!"

mainDo :: IO ()
mainDo = do
  name <- getLine
  let statement = helloPerson name
  putStrLn statement

-- My vision
mainBind :: IO ()
mainBind = getLine >>= (\name -> return (helloPerson name)) >>= putStrLn

-- Official vision? Or just approximation by Will Kurt?
mainAnother :: IO ()
mainAnother = getLine >>= (\name -> (\statement -> putStrLn statement) (helloPerson name))

-- Candidate choosing application
data Grade = F | D | C | B | A deriving (Eq, Ord, Show, Enum, Read)

data Degree = HS | BA | MS | PhD deriving (Eq, Ord, Show, Enum, Read)

data Candidate = Candidate
  { candidateId :: Int
  , codeReview :: Grade
  , cultureFit :: Grade
  , education :: Degree } deriving Show

viable :: Candidate -> Bool
viable candidate = all (== True) tests
  where passedCoding = codeReview candidate > B
        passedCultureFit = cultureFit candidate > C
        educationMin = education candidate >= MS
        tests = [passedCoding
                ,passedCultureFit
                ,educationMin]

readInt :: IO Int
readInt = getLine >>= (return . read)

readGrade :: IO Grade
readGrade = getLine >>= (return . read)

readDegree :: IO Degree
readDegree = getLine >>= (return . read)

readCandidate :: IO Candidate
readCandidate = do
   putStrLn "Enter id:"
   cId <- readInt
   putStrLn "Enter code grade:"
   codeGrade <- readGrade
   putStrLn "Enter culture fit grade:"
   cultureGrade <- readGrade
   putStrLn "Enter education:"
   degree <- readDegree
   return (Candidate { candidateId = cId
                     , codeReview = codeGrade
                     , cultureFit = cultureGrade
                     , education = degree })

assessCandidateIO :: IO String
assessCandidateIO = do
   candidate <- readCandidate
   let passed = viable candidate
   let statement = if passed
                   then "passed"
                   else "failed"
   return statement

candidate1 :: Candidate
candidate1 = Candidate { candidateId = 1
                        , codeReview = A
                        , cultureFit = A
                        , education = BA }
candidate2 :: Candidate
candidate2 = Candidate { candidateId = 2
                        , codeReview = C
                        , cultureFit = A
                        , education = PhD }

candidate3 :: Candidate
candidate3 = Candidate { candidateId = 3
                        , codeReview = A
                        , cultureFit = B
                        , education = MS }

candidateDB :: Map.Map Int Candidate
candidateDB = Map.fromList [(1,candidate1)
                            ,(2,candidate2)
                            ,(3,candidate3)]

candidates :: [Candidate]
candidates = [candidate1
              ,candidate2
              ,candidate3]

assessCandidateMaybe :: Int -> Maybe String
assessCandidateMaybe cId = do
   candidate <- Map.lookup cId candidateDB
   let passed = viable candidate
   let statement = if passed
                   then "passed"
                   else "failed"
   return statement

-- Code for list looks like we work with one candidate, but we actually
-- iterate over list. How to desugar this do notation?
-- I think the anser for this in the implementation for a list + do notation.
assessCandidateList :: [Candidate] -> [String]
assessCandidateList candidates = do
   candidate <- candidates
   let passed = viable candidate
   let statement = if passed
                   then "passed"
                   else "failed"
   return statement


-- Super abstract assessCandidate works for every Monad possible.
assessCandidate :: Monad m =>  m Candidate -> m String
assessCandidate candidates = do
   candidate <- candidates
   let passed = viable candidate
   let statement = if passed
                   then "passed"
                   else "failed"
   return statement
