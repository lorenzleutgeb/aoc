{- stack script
 --resolver ghc-8.10.2
 --package split
 -}

import Data.List.Split (splitOn)

p :: Int -> [Int] -> Int
p i fish = go i [(length . filter (== j)) fish | j <- [0 .. 8]]
  where
    go 0 day = sum day
    go i day = go (i - 1) [d 1, d 2, d 3, d 4, d 5, d 6, d 7 + z, d 8, z]
      where
        d j = day !! j
        z = d 0

main :: IO ()
main = do
  fish <- (map read . splitOn ",") . head . lines <$> getContents
  print $ p 80 fish
  print $ p 256 fish
