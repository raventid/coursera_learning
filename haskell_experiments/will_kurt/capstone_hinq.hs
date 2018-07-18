import Control.Monad
import Control.Applicative -- for Alternative typeclass

data Name = Name
             { firstName ::String
             , lastName :: String }

instance Show Name where
  show (Name first last) = mconcat [first," ",last]

data GradeLevel = Freshman
  | Sophmore
  | Junior
  | Senior deriving (Eq, Ord, Enum, Show)

data Student = Student
    { studentId :: Int
    , gradeLevel :: GradeLevel
    , studentName :: Name } deriving Show

students :: [Student]
students = [(Student 1 Senior (Name "Audre" "Lorde"))
           ,(Student 2 Junior (Name "Leslie" "Silko"))
           ,(Student 3 Freshman (Name "Judith" "Butler"))
           ,(Student 4 Senior (Name "Guy" "Debord"))
           ,(Student 5 Sophmore (Name "Jean" "Baudrillard"))
           ,(Student 6 Junior (Name "Julia" "Kristeva"))]


_select :: Monad m => (a -> b) -> m a -> m b
_select prop vals = do
  val <- vals
  return (prop val)

-- Specs for _select function.
specSelectBasic = _select (firstName . studentName) students
-- Composition power.
specSelectMultipleProps = _select (\x -> (studentId x, gradeLevel x, studentName x)) students

_where :: (Monad m, Alternative m) => (a -> Bool) -> m a -> m a
_where test vals = do
  val <- vals
  guard (test val)
  return val

specWhere = _where ((\name -> 'J' == head name) . firstName) (_select studentName students)

-- Teacher and Course structures.

data Teacher = Teacher
  { teacherId :: Int
  , teacherName :: Name } deriving Show

teachers :: [Teacher]
teachers = [Teacher 100 (Name "Simone" "De Beauvior")
           ,Teacher 200 (Name "Susan" "Sontag")]

data Course = Course
  { courseId :: Int
  , courseTitle :: String
  , teacher :: Int } deriving Show

courses :: [Course]
courses = [Course 101 "French" 100
          ,Course 201 "English" 200]

_join :: (Monad m, Alternative m, Eq c) => m a -> m b -> (a -> c) -> (b -> c) -> m (a,b)
_join data1 data2 prop1 prop2 = do
  d1 <- data1
  d2 <- data2
  let dpairs = (d1,d2)
  guard ((prop1 (fst dpairs)) == (prop2 (snd dpairs))) -- typo page 419
  return dpairs

innerJoiningSpec = selectResult
  where joinData = (_join teachers courses teacherId teacher)
        whereResult = _where ((== "English") . courseTitle . snd) joinData
        selectResult = _select (teacherName . fst) whereResult

_hinq selectQuery joinQuery whereQuery =
  (\joinData -> (\whereResult -> selectQuery whereResult) (whereQuery joinData)) joinQuery

finalResult :: [Name]
finalResult = _hinq (_select (teacherName . fst))
                    (_join teachers courses teacherId teacher)
                    (_where ((== "English") .courseTitle . snd))

