{- stack script
 --resolver ghc-8.10.2
 -}
import Data.List       as L
import Data.List.Split as LS
import Data.Set        as S

type Point = (Int, Int)

origin :: Point
origin = (0, 0)

manhattan (x1, y1) (x2, y2) = (abs $ x1 - x2) + (abs $ y1 - y2)

data Direction = U | D | L | R deriving (Read, Show)

neighbor (x, y) R = (x + 1, y)
neighbor (x, y) L = (x - 1, y)
neighbor (x, y) U = (x, y + 1)
neighbor (x, y) D = (x, y - 1)

type Movement = (Direction, Int)

parse :: String -> Movement
parse (x:xs) = (read [x], read xs)

explode _ []          = S.empty
explode c ((_, 0):ms) = explode c ms
explode c ((d, l):ms) = S.insert c (explode (neighbor c d) ((d, l - 1):ms))

crossings [a, b] = toList $ S.delete origin $ intersection a b

main = interact $ show . minimum
  . L.map (manhattan origin) . crossings
  . L.map (explode origin . (\x -> L.map parse (LS.splitOn "," x)))
  . lines
