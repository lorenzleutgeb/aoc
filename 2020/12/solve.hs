{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 -}

import Data.Char
import Data.Foldable
import Data.Map (Map, fromList, mapWithKey)
import qualified Data.Map as M (lookup)
import Data.Maybe

type Vec = (Int, Int)

type World = Map Vec Char

type Action = (Char, Int)

act :: Int -> Vec -> Char -> Int -> (Int, Vec)
act d p a v
  | a `elem` ['N', 'E', 'S', 'W'] = (d, (add p (mul (char2vec a) v)))
  | a == 'R' = ((d + v) `mod` 360, p)
  | a == 'L' = ((d - v) `mod` 360, p)
  | a == 'F' = (d, (add p (mul (deg2vec d) v)))
  | otherwise = error "Unknown action"

act2 :: Vec -> Vec -> Char -> Int -> (Vec, Vec)
act2 wp p a v
  | a `elem` ['N', 'E', 'S', 'W'] = ((add wp (mul (char2vec a) v)), p)
  | a == 'R' = (rot (v `div` 90) wp, p)
  | a == 'L' = (rot ((360 - v) `div` 90) wp, p)
  | a == 'F' = (wp, (add p (mul wp v)))
  | otherwise = error "Unknown action"

char2vec 'N' = south
char2vec 'E' = east
char2vec 'S' = north
char2vec 'W' = west

deg2vec 0 = east
deg2vec 90 = south
deg2vec 180 = west
deg2vec 270 = north

rot :: Int -> Vec -> Vec
rot 0 p = p
rot 1 (x, y) = (y, - x)
rot 2 (x, y) = (- x, - y)
rot 3 (x, y) = (- y, x)
rot n p = rot (n `mod` 4) p

mul :: Vec -> Int -> Vec
mul (x, y) k = (x * k, y * k)

add :: Vec -> Vec -> Vec
add (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

north :: Vec
north = (0, -1)

east :: Vec
east = (1, 0)

south :: Vec
south = (0, 1)

west :: Vec
west = (-1, 0)

p1 :: [(Char, Int)] -> Int
p1 = (\(x, y) -> (abs x) + (abs y)) . snd . foldl (\(d, p) (a, v) -> act d p a v) (0, (0, 0))

p2 :: [(Char, Int)] -> Int
p2 = (\(x, y) -> (abs x) + (abs y)) . snd . foldl (\(wp, p) (a, v) -> act2 wp p a v) ((10, 1), (0, 0))

main :: IO ()
main = do
  world <- map (\(l, r) -> (head l, read r)) . map (span (not . isDigit)) . lines <$> getContents
  print $ p1 world
  print $ p2 world
