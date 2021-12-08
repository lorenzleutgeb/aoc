{- stack script
 --resolver ghc-8.10.2
 --package split
 -}

import Data.List (elemIndex, find, permutations, sort)
import Data.List.Split (splitOn)
import Data.Maybe (fromJust)

normalized = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

parse :: String -> ([String], [String])
parse =
  (\[i, o] -> (i, o))
    . (map (splitOn " ") . (splitOn " | "))

p1 :: [([String], [String])] -> Int
p1 = sum . map (length . filter ((flip elem [2, 3, 4, 7]) . length)) . map snd

pmaps :: Eq a => [a] -> [a -> a]
pmaps xs = [(\x -> p !! (fromJust $ elemIndex x xs)) | p <- permutations xs]

dec :: [Int] -> Int
dec xs = foldl (\x y -> 10 * x + y) 0 xs

p2 :: [([String], [String])] -> Int
p2 lns = sum $ map one lns
  where
    one (a, b) = num (p a) b
    norm p = sort . map p
    num p b = dec $ map (fromJust . (\x -> elemIndex x normalized) . norm p) b
    p a = fromJust $ find (valid a) $ pmaps "abcdefg"
    valid a p = all ((flip elem) normalized) (map (norm p) a)

main :: IO ()
main = do
  lns <- map parse . lines <$> getContents
  print $ p1 lns
  print $ p2 lns
