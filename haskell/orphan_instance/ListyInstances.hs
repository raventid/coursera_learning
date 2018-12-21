-- From root of the directory run this script:
-- stack exec -- ghc -I. --make ListyInstances.hs
module ListyInstance where

import Data.Monoid
import Listy

instance Semigroup (Listy a) where
  (<>) (Listy l) (Listy l') = Listy $ (<>) l l'

instance Monoid (Listy a) where
  mempty = Listy []
  mappend (Listy l) (Listy l') = Listy $ mappend l l'


-- So we have the same definition in a file next to this one.
-- GHC helpfully gives us an information about duplicate typeclass definition.
--
-- THIS SHOULD BE AVOIDED AT ALL COST
--
--
--
-- [2 of 2] Compiling ListyInstance    ( ListyInstances.hs, ListyInstances.o )

-- ListyInstances.hs:8:10: error:
--     Duplicate instance declarations:
--       instance Semigroup (Listy a) -- Defined at ListyInstances.hs:8:10
--       instance [safe] Semigroup (Listy a) -- Defined in ‘Listy’
--   |
-- 8 | instance Semigroup (Listy a) where
--   |          ^^^^^^^^^^^^^^^^^^^

-- ListyInstances.hs:11:10: error:
--     Duplicate instance declarations:
--       instance Monoid (Listy a) -- Defined at ListyInstances.hs:11:10
--       instance [safe] Monoid (Listy a) -- Defined in ‘Listy’
--    |
-- 11 | instance Monoid (Listy a) where
--    |          ^^^^^^^^^^^^^^^^
