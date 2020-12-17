{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 -}

import Data.Foldable
import Data.Maybe
import Data.Map (Map, fromList, keys, findWithDefault)
import qualified Data.Map as M (lookup)

type Vec = (Int, Int, Int)

type World = Map Vec Char

indexed :: (Num b, Enum b) => [a] -> [(b, a)]
indexed = zip [0..]

indexed2 :: (Num b, Enum b) => [[a]] -> [((b, b), a)]
indexed2 = foldl (++) [] . map (\(x, l) -> map (\(y, e) -> ((x, y), e)) l) . indexed . map indexed

indexed3 :: [[Char]] -> [(Vec, Char)]
indexed3 = map (\((x, y), c) -> ((x, y, 0), c)) . indexed2

input :: [[Char]]
input = [
    ['#','.','#','#','#','#','#','.'],
    ['#','.','.','#','#','.','.','.'],
    ['.','#','#','.','.','#','.','.'],
    ['#','.','#','#','.','#','#','#'],
    ['.','#','.','#','.','#','.','.'],
    ['#','.','#','#','.','.','#','.'],
    ['#','#','#','#','#','.','.','#'],
    ['.','.','#','.','#','.','#','#']
  ]

dirs :: [Vec]
dirs = [ (x, y, z) | x <- [-1 .. 1], y <- [-1 .. 1], z <- [-1 .. 1], not $ (x == 0) && (y == 0) && (z == 0) ]

add :: Vec -> Vec -> Vec
add (x1, y1, z1) (x2, y2, z2) = (x1 + x2, y1 + y2, z1 + z2)

type Adj = World -> Vec -> [Char]

adjImm :: World -> Vec -> [Char]
adjImm world v = catMaybes $ map (\v' -> M.lookup v' world) $ adjVecs v

adjVecs :: Vec -> [Vec]
adjVecs v = add v <$> dirs

step :: World -> World
step world = fromList $ stepCell <$> lookup' <$> around
  where
   lookup' k = (k, findWithDefault '.' k world)
   stepCell (k, v) = (k, cell v $ adjImm world k)
   ks = keys world
   around = ks ++ (foldr1 (++) (adjVecs <$> ks))

count :: (Eq a) => a -> [a] -> Int
count x = length . filter (x==)

cell :: Char -> [Char] -> Char
cell '.' adj | count '#' adj == 3 = '#'
             | otherwise = '.'
cell '#' adj | count '#' adj == 2 || count '#' adj == 3 = '#'
             | otherwise = '.'
cell c _ = c

active :: World -> Int
active = count '#' . toList 

solve :: World -> Int
solve world = active $ (iterate step world) !! 6

main :: IO ()
main = do
  print $ solve $ fromList $ indexed3 input
