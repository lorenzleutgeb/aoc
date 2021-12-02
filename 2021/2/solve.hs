{- stack script
 --resolver ghc-8.10.2
 --package split
 -}

import Data.List (tails)
import Data.List as L
import Data.List.Split as LS

data Direction = D | U | F deriving (Eq, Read, Show)

parseDirection "down" = D
parseDirection "up" = U
parseDirection "forward" = F

parse :: String -> [(Direction, Int)]
parse =
  L.map (\x -> (parseDirection (x !! 0), (read (x !! 1)) :: Int))
    . L.map (LS.splitOn " ")
    . lines

p1 :: [(Direction, Int)] -> Int
p1 = (uncurry (*)) . foldl f (0, 0)
  where
    f (depth, dist) (dir, x)
      | dir == D = (depth + x, dist)
      | dir == U = (depth - x, dist)
      | dir == F = (depth, dist + x)

p2 :: [(Direction, Int)] -> Int
p2 = (\(x, y, _) -> x * y) . foldl f (0, 0, 0)
  where
    f (depth, dist, aim) (dir, x)
      | dir == D = (depth, dist, aim + x)
      | dir == U = (depth, dist, aim - x)
      | dir == F = (depth + aim * x, dist + x, aim)

main :: IO ()
main = do
  cmds <- parse <$> getContents
  print $ p1 cmds
  print $ p2 cmds
