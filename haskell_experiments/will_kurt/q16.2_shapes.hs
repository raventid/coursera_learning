module Shapes where

type Radius = Float
type Height = Float
type Width = Float

pi = 3.14


data Shape = Circle Radius
           | Square Height
           | Rectangle Height Width

perimeter :: Shape -> Float
perimeter (Circle r) = 2*Shapes.pi*r
perimeter (Square h) = 4*h
perimeter (Rectangle h w) = (2*h)+(2*w)

area :: Shape -> Float
area (Circle r) = Shapes.pi*r*r
area (Square h) = h*h
area (Rectangle h w) = h*w

-- Test for REPL
c = Circle 10
s = Square 11

t1 = perimeter c
t2 = perimeter s

t3 = area c
t4 = area s
