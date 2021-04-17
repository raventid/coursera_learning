module Matrixes

import Data.Vect

sum : Num numType => Vect rows (Vect cols numType) ->
                     Vect rows (Vect cols numType) ->
                     Vect rows (Vect cols numType)
