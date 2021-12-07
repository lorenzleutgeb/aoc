{- stack script
 --resolver ghc-8.10.2
 --package split
 -}

import Data.List (sort)
import Data.List.Split (splitOn)

median :: Integral a => [a] -> a
median [] = undefined
median [x] = x
median xs' = if even $ length xs then xm else xs !! m
  where
    xs = sort xs'
    m = length xs `div` 2
    xm = (xs !! m + xs !! (m - 1)) `div` 2

absDiff :: Num a => a -> a -> a
absDiff x y = abs $ x - y

p1 :: Integral a => [a] -> a
p1 ns = sum $ map cost ns
  where
    cost x = absDiff x $ median ns

p2 :: Integral a => [a] -> a
p2 ns = minimum $ map cost range
  where
    range = [minimum ns .. maximum ns]
    gauss n = (n * (n + 1)) `div` 2
    cost x = sum $ map (gauss . absDiff x) ns

main :: IO ()
main = do
  fish <- (map read . splitOn ",") . head . lines <$> getContents
  print $ p1 fish
  print $ p2 fish
