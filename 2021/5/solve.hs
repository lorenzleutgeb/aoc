{- stack script
 --resolver ghc-8.10.2
 --package split
 -}

import Data.List (group, sort)
import Data.List.Split (splitOn)

type Point = (Int, Int)

type Line = (Point, Point)

parse :: String -> Line
parse =
  (\[[x1, y1], [x2, y2]] -> ((read x1, read y1), (read x2, read y2)))
    . (map (splitOn ",") . (splitOn " -> "))

p :: [Line] -> Int
p = length . filter ((> 1) . length) . group . sort . concat . map points

points :: Line -> [Point]
points (p1@(x1, y1), p2@(x2, y2))
  | p1 == p2 = [p1]
  | otherwise = [p1] ++ (points (p1', p2))
  where
    p1'
      | x1 == x2 && y1 < y2 = (x1, y1 + 1)
      | x1 == x2 && y1 > y2 = (x1, y1 - 1)
      | x1 < x2 && y1 == y2 = (x1 + 1, y1)
      | x1 > x2 && y1 == y2 = (x1 - 1, y1)
      | x1 > x2 && y1 > y2 = (x1 - 1, y1 - 1)
      | x1 > x2 && y1 < y2 = (x1 - 1, y1 + 1)
      | x1 < x2 && y1 > y2 = (x1 + 1, y1 - 1)
      | x1 < x2 && y1 < y2 = (x1 + 1, y1 + 1)

main :: IO ()
main = do
  lns <- map parse . lines <$> getContents
  print $ p $ filter ortho lns
  print $ p lns
  where
    ortho ((x1, y1), (x2, y2)) = x1 == x2 || y1 == y2
