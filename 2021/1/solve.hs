{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List (tails)

p1 :: Ord a => [a] -> Int
p1 ns = length $ filter (== True) $ zipWith (<) ns (tail ns)

p2 :: (Ord a, Num a) => [a] -> Int
p2 = p1 . map (sum . take 3) . tails

main :: IO ()
main = do
  ns <- map read . lines <$> getContents
  print $ p1 ns
  print $ p2 ns
