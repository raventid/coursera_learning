module Expand45 where

infixl 6 :+:
infixl 7 :*:
data Expr = Val Int | Expr :+: Expr | Expr :*: Expr
    deriving (Show, Eq)

-- expand :: Expr -> Expr
-- expand ((e1 :+: e2) :*: e) = expand e1 :*: expand e :+: expand e2 :*: expand e
-- expand (e :*: (e1 :+: e2)) = expand e :*: expand e1 :+: expand e :*: expand e2
-- expand (e1 :+: e2) = expand e1 :+: expand e2
-- expand (e1 :*: e2) = expand e1 :*: expand e2
-- expand e = e
expand :: Expr -> Expr
expand ((e1 :+: e2) :*: e) = expand (e1 :*: e) :+: expand (e2 :*: e)
expand (e :*: (e1 :+: e2)) = expand (e :*: e1) :+: expand (e :*: e2)
expand (e1 :+: e2) = expand e1 :+: expand e2
expand (e1 :*: e2) =
  let
    c = expand e1
    c' = expand e2
  in
    if e1 == c && c' == e2 then c :*: c' else expand $ expand c :*: expand c'
expand e = e


 --  (x + y + z) * (a + b)


 --  (x + y)
 --    x1 + z     (a + b)
 --      x2    *    a1






 --  (x + y + ((a + b + c) * d)) * (z + e)


 --  a + b + ..
  

 -- (Val :+: (Val :+: Val))

 --  Как только вижу ближайшее умножение на a:

 --  (Val' :+: (Val' :+: Val')), where Val' = Val :*: a, where a = Val

 --  next step

 --  (Val x :+: Val y :+: Val' a :+: Val' b :+: Val' d) :*: (Val z :+: Val e)


 --  e :*: e' = let expand (a + b + c) (a' + b' + c') in [ e :*: e' | e <- expand left, e' <- expand right ] expand (a + b + c) (a' + b' + c')


 --                     :*: Val d
 --                     /
 --                   :+: Val c
 --                   /
 --            Val a :+: Val b


-- Endo a = a -> a

-- Int -> Int

-- (Int -> Int) -> (Int -> Int)
