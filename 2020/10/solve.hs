{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 -}

import Data.List

diffs :: [Int] -> [Int]
diffs ns = zipWith (-) (tail ns) ns

bound :: [Int] -> [Int]
bound ns = [0] ++ ns ++ [maximum ns + 3]

parse :: String -> [Int]
parse = diffs . bound . sort . map read . lines

p1 :: [Int] -> Int
p1 ds = (length $ filter ((==) 1) ds) * (length $ filter ((==) 3) ds)

trib :: [Int]
trib = 1:1:2:(zipWith3 (\x y z -> x+y+z) trib (tail trib) (tail $ tail trib))

p2 :: [Int] -> Int
p2 ds = product $ map ((trib !!) . length) $ filter ((==) 1 . head) $ group ds

main :: IO ()
main = do
  ds <- parse <$> getContents
  print $ p1 ds 
  print $ p2 ds
