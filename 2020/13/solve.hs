{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 --package arithmoi
 -}

import Data.List.Split
import Data.Maybe
import Math.NumberTheory.Moduli.Chinese (chineseRemainder)

p1 :: Int -> [Int] -> Int
p1 t bs = head $ [dt * b | dt <- [0 ..], b <- bs, (t + dt) `mod` b == 0]

p2 :: [(Integer, Integer)] -> Integer
p2 = fromJust . chineseRemainder

-- Brute force:
-- p2 bs = head $ [ t | t <- [1 ..], all (\(bt, bf) -> (bt + t) `mod` bf == 0) bs]

main :: IO ()
main = do
  ls <- lines <$> getContents
  let earliest = read $ (ls !! 0)
  let buses = splitOn "," (ls !! 1)
  print $ p1 earliest $ map read $ filter (/= "x") buses
  print $ p2 $ map (\(a, b) -> (- a, toInteger $ read b)) $ filter ((/= "x") . snd) $ zip [0 ..] buses
