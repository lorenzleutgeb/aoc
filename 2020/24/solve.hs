{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 -}

import Data.List
import Data.Set (Set, fromList, intersection, member, size)
import qualified Data.Set as S (filter, map, union)

-- cube coordinates, see https://www.redblobgames.com/grids/hexagons/
type Vec = (Int, Int, Int)

add :: Vec -> Vec -> Vec
add (x1, y1, z1) (x2, y2, z2) = (x1 + x2, y1 + y2, z1 + z2)

east :: Vec
east = (1, -1, 0)

northeast :: Vec
northeast = (1, 0, -1)

northwest :: Vec
northwest = (0, 1, -1)

west :: Vec
west = (-1, 1, 0)

southwest :: Vec
southwest = (-1, 0, 1)

southeast :: Vec
southeast = (0, -1, 1)

dirs :: [Vec]
dirs = [east, northeast, northwest, west, southwest, southeast]

zero :: Vec
zero = (0, 0, 0)

next :: String -> [Vec]
next ('e' : s') = east : next s'
next ('n' : 'e' : s') = northeast : next s'
next ('n' : 'w' : s') = northwest : next s'
next ('w' : s') = west : next s'
next ('s' : 'w' : s') = southwest : next s'
next ('s' : 'e' : s') = southeast : next s'
next [] = []
next _ = error "Unknown direction"

pattern :: [[Vec]] -> Set Vec
pattern = fromList . map head . filter (odd . length) . group . sort . map (foldr add zero)

p1 :: Set Vec -> Int
p1 = size

close :: Set Vec -> Set Vec
close black = foldr S.union black $ S.map neighbors $ black

neighbors :: Vec -> Set Vec
neighbors x = fromList $ map (add x) dirs

step :: Set Vec -> Vec -> Bool
step black x
  | isBlack && (blackNeighbors == 0 || blackNeighbors > 2) = False
  | (not isBlack) && blackNeighbors == 2 = True
  | otherwise = isBlack
  where
    isBlack = member x black
    blackNeighbors = length $ intersection black (neighbors x)

p2 :: Set Vec -> Int
p2 initialPattern = size $ iterate go initialPattern !! 100
  where
    go black = S.filter (step black) $ close black

main :: IO ()
main = do
  initialPattern <- pattern . map next . lines <$> getContents
  print $ p1 initialPattern
  print $ p2 initialPattern
