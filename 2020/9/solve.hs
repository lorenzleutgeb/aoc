{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 -}

import Data.List

window :: Int
window = 25

valid :: [Int] -> Int -> Bool
valid ns i
  | i <= window = True
  | otherwise = or [x + y == ns !! i | x <- pre, y <- pre]
  where
    pre = take window . drop (i - window) $ ns

p1 :: [Int] -> Int
p1 ns = head $ [x | (i, x) <- zip [0 ..] ns, not $ valid ns i]

p2 :: [Int] -> Int
p2 ns = minimum ms + maximum ms
  where
    ms = sublistSum ns (p1 ns) 2

sublistSum :: [Int] -> Int -> Int -> [Int]
sublistSum ns m k = case find ((==) m . sum) $ takes ns k of
  Nothing -> sublistSum ns m (k + 1)
  Just xs -> xs

takes :: [Int] -> Int -> [[Int]]
takes [] _ = []
takes xs n = take n xs : takes (tail xs) n

main :: IO ()
main = do
  ns <- map read . lines <$> getContents
  print $ p1 ns
  print $ p2 ns
