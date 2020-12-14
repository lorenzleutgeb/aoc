{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 --package containers
 -}

import Data.Char (digitToInt, intToDigit)
import Data.List (foldl')
import Data.List.Split
import Data.Map (Map, empty, insert, toList)

width :: Int
width = 36

toBin :: Int -> [Char]
toBin x = (\xs -> (take (width - length xs) $ repeat '0') ++ xs) $ reverse $ go x
  where
    go 0 = []
    go y = let (a, b) = quotRem y 2 in [intToDigit b] ++ go a

toDec :: String -> Int
toDec = foldl' (\acc x -> acc * 2 + digitToInt x) 0

applyMask :: [Char] -> [Char] -> [Char]
applyMask [] [] = []
applyMask (y : ys) (x : xs)
  | x == 'X' = y : zs
  | otherwise = x : zs
  where
    zs = applyMask ys xs
applyMask _ _ = error "Mask length mismatch"

applyMemMask :: [Char] -> [Char] -> [[Char]]
applyMemMask [] [] = [[]]
applyMemMask (y : ys) (x : xs)
  | x == 'X' = (mapCons '0') ++ (mapCons '1')
  | x == '1' = mapCons '1'
  | x == '0' = mapCons y
  | otherwise = error "Unknown mask"
  where
    zs = applyMemMask ys xs
    mapCons z = map (z :) zs
applyMemMask _ _ = error "Mask length mismatch"

type Writer = Map Int Int -> String -> Int -> Int -> Map Int Int

run :: Writer -> [String] -> Int
run writer = sum . map snd . toList . snd . Prelude.foldl go ("", Data.Map.empty)
  where
    go (_, mem) ('m' : 'a' : 's' : 'k' : ' ' : '=' : ' ' : xs) = (xs, mem)
    go (mask, mem) ('m' : 'e' : 'm' : '[' : xs) = (mask, (\[addr, v] -> writer mem mask (read addr) (read v)) $ splitOn "] = " xs)
    go _ _ = error "Unknown line"

write1 :: Writer
write1 mem mask addr v = insert addr v' mem
  where v' = toDec $ applyMask (toBin v) mask

write2 :: Writer
write2 mem mask addr v = foldl (\mem' addr' -> insert addr' v mem') mem addrs
  where addrs = map toDec $ applyMemMask (toBin addr) mask

main :: IO ()
main = do
  ls <- lines <$> getContents
  print $ run write1 ls
  print $ run write2 ls
