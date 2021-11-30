{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List as L
import Data.List.Split as LS
import Data.Map as M
import Data.Maybe as Mb
import Data.Set as S

type Point = (Int, Int)

origin :: Point
origin = (0, 0)

neighbor (x, y) R = (x + 1, y)
neighbor (x, y) L = (x - 1, y)
neighbor (x, y) U = (x, y + 1)
neighbor (x, y) D = (x, y - 1)

data Direction = U | D | L | R deriving (Read, Show)

type Movement = (Direction, Int)

parse :: String -> Movement
parse (x : xs) = (read [x], read xs)

alterIfSmaller x Nothing = Just x
alterIfSmaller x (Just y) = Just (min x y)

explode s ps ss _ [] = (ps, ss)
explode s ps ss c ((_, 0) : ms) = explode s ps ss c ms
explode s ps ss c ((d, l) : ms) = (S.insert c ps', M.alter (alterIfSmaller s) c ss')
  where
    (ps', ss') = (explode (s + 1) ps ss (neighbor c d) ((d, l - 1) : ms))

addLookups a b k = (Mb.fromJust $ M.lookup k a) + (Mb.fromJust $ M.lookup k b)

crossings :: [(Set Point, Map Point Int)] -> [Int]
crossings [(aps, ass), (bps, bss)] = L.map (addLookups ass bss) $ S.toList $ S.delete origin (S.intersection aps bps)

main =
  interact $
    show
      . minimum
      . crossings
      . L.map (explode 0 S.empty M.empty origin . (\x -> L.map parse (LS.splitOn "," x)))
      . lines
