{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package lens
 -}

import Control.Lens

data Cell = Open | Tree deriving (Enum)

parse :: Char -> Cell
parse '.' = Open
parse '#' = Tree
parse _ = error "Invalid input"

type World = [[Cell]]

type Vec = (Int, Int)

x :: Lens' Vec Int
x = _1

y :: Lens' Vec Int
y = _2

add :: Vec -> Vec -> Vec
add a b = (a ^. x + b ^. x, a ^. y + b ^. y)

slopes :: [Vec]
slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

main :: IO ()
main =
  interact $
    show
      . product
      . (\pattern -> map (\slope -> count pattern slope (0, 0)) slopes)
      . map (map parse)
      . lines

count :: World -> Vec -> Vec -> Int
count pattern slope v
  | v ^. y >= length pattern = 0
  | otherwise = (fromEnum $ (pattern !! (v ^. y)) !! (v ^. x)) + count pattern slope (bound pattern $ add slope v)

bound :: World -> Vec -> Vec
bound pattern = over x $ flip mod $ length $ head pattern
