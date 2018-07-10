module SixSidedDie where

data SixSidedDie =
   S1
 | S2
 | S3
 | S4
 | S5
 | S6

-- This is incorrect way to implement show for this type, but..
show :: SixSidedDie -> String
show S1 = "one"
show S2 = "two"
show S3 = "three"
show S4 = "four"
show S5 = "five"
show S6 = "six"
-- Problem with code above is that:
-- Ambiguous occurrence ‘show’
    -- It could refer to either ‘Prelude.show’, or ‘SixSidedDie.show’
-- We are lacking polymorphism here, we should write the code the way
-- we always call standard polymorhic `show` (that's a story about modules)

instance Eq SixSidedDie where
  (==) S1 S1 = True
  (==) S2 S2 = True
  (==) S3 S3 = True
  (==) S4 S4 = True
  (==) S5 S5 = True
  (==) S6 S6 = True
  (==) _ _ = False -- (/=) will work automatically!

instance Enum SixSidedDie where
  toEnum 0 = S1
  toEnum 1 = S2
  toEnum 2 = S3
  toEnum 3 = S4
  toEnum 4 = S5
  toEnum 5 = S6
  toEnum _ = error "No such value, sorry"

  fromEnum S1 = 0
  fromEnum S2 = 1
  fromEnum S3 = 2
  fromEnum S4 = 3
  fromEnum S5 = 4
  fromEnum S6 = 5
