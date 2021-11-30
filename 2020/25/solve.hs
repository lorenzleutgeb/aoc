{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package arithmoi
 -}

import Math.NumberTheory.Powers.Modular (powMod)

m :: Int
m = 20201227

card :: Int
card = 9232416

door :: Int
door = 14144084

main :: IO ()
main = do
  print $ powMod card (head [i | i <- [3 ..], powMod 7 i m == door]) m
