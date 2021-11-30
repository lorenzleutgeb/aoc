{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 -}

import Data.Foldable
import Data.Map (Map, fromList, mapWithKey)
import qualified Data.Map as M (lookup)
import Data.Maybe

type Vec = (Int, Int)

type World = Map Vec Char

type Adj = World -> Vec -> [Char]

fixed :: Eq a => (a -> a) -> a -> a
fixed = until =<< ((==) =<<)

indexed :: (Num b, Enum b) => [a] -> [(b, a)]
indexed = zip [0 ..]

indexed2 :: (Num b, Enum b) => [[a]] -> [((b, b), a)]
indexed2 = foldl (++) [] . map (\(x, l) -> map (\(y, e) -> ((x, y), e)) l) . indexed . map indexed

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

orthogonal :: [Vec]
orthogonal = [north, east, south, west]

northeast :: Vec
northeast = add north east

southeast :: Vec
southeast = add south east

southwest :: Vec
southwest = add south west

northwest :: Vec
northwest = add north west

diagonal :: [Vec]
diagonal = [northeast, southeast, southwest, northwest]

dirs :: [Vec]
dirs = orthogonal ++ diagonal

count :: Eq a => a -> [a] -> Int
count x = length . filter (x ==)

step :: Int -> (World -> Vec -> [Char]) -> World -> World
step n adj world = mapWithKey (\k v -> cell n v $ adj world k) world

adjImm :: World -> Vec -> [Char]
adjImm world k = catMaybes [M.lookup (add k d) world | d <- dirs]

adjLaser :: World -> Vec -> [Char]
adjLaser world k = catMaybes [laser k d | d <- dirs]
  where
    laser o d = let l = add o d in M.lookup l world >>= (\x -> if x == '.' then laser l d else Just x)

cell :: Int -> Char -> [Char] -> Char
cell _ 'L' adj | notElem '#' adj = '#'
cell n '#' adj | count '#' adj >= n = 'L'
cell _ c _ = c

p :: Int -> Adj -> World -> Int
p n a = occupied . fixed (step n a)

occupied :: World -> Int
occupied = length . filter ('#' ==) . toList

p1 :: World -> Int
p1 = p 4 adjImm

p2 :: World -> Int
p2 = p 5 adjLaser

main :: IO ()
main = do
  world <- fromList . indexed2 . lines <$> getContents
  print $ p1 world
  print $ p2 world
