{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 --package lens
 --package split
 -}

import Data.List
import Data.List.Split
import Data.Maybe
import Debug.Trace

ltop :: [a] -> (a, a)
ltop [x, y] = (x, y)

type Range = (String, [(Int, Int)])

mkld :: [String] -> (String, [(String, String)])
mkld = (\[field, ranges] -> (field, map ltop $ map (splitOn "-") $ splitOn " or " ranges))

mkl :: [String] -> (String, [(Int, Int)])
mkl = (\[field, ranges] -> (field, map ltop $ map ((map read) . splitOn "-") $ splitOn " or " ranges))

mkr :: String -> [(String, [(Int, Int)])]
mkr ranges' = map mkl $ map (splitOn ": ") $ lines ranges'

inr x (min, max) = x >= min && x <= max

inrs x rs = any (inr x) rs

matchAny ranges x = any (\(_, ranges') -> inrs x ranges') ranges

toAllMatchingRange :: [Range] -> [Int] -> [String]
toAllMatchingRange ranges xs = map fst $ filter (\(_, rs) -> all (\x -> inrs x rs) xs) ranges

readTicket :: String -> [Int]
readTicket = map read . splitOn ","

main :: IO ()
main = do
  contents <- getContents
  let [ranges', my', nearby'] = splitOn "\n\n" contents
  let ranges = mkr ranges'
  let nearby = map readTicket $ tail $ lines nearby'
  print $ sum $ map sum $ traceShowId $ map (filter (not . matchAny ranges)) nearby
  let my = readTicket $ last $ lines my'
  let validNearby = traceShowId $ filter (\xs -> all (matchAny ranges) xs) nearby
  let vnt = traceShowId $ transpose (my : validNearby)
  let rangeOrder = map (toAllMatchingRange ranges) vnt
  print rangeOrder
