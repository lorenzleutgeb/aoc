{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 --package containers
 -}

import Data.Bifunctor
import Data.Char
import Data.List
import Data.List.Split
import qualified Data.Map as M (Map, fromList, lookup)
import Data.Maybe

ltop :: [a] -> (a, a)
ltop [x1, x2] = (x1, x2)
ltop _ = error "Can only convert list with exactly two elements to pair"

trimSuffix :: Eq a => [a] -> [a] -> [a]
trimSuffix xs ys = case stripPrefix (reverse xs) (reverse ys) of
  Nothing -> ys
  Just zs -> reverse zs

parse :: String -> [(Int, String)]
parse "no other bags" = []
parse s = map (readSpan . trimOneOrMany) $ splitOn ", " s
  where
    readSpan = (bimap read tail) . (span isDigit)
    trimOneOrMany = trimSuffix " bags" . trimSuffix " bag"

cost :: String -> M.Map String [(Int, String)] -> Int
cost bag rules = sum $ map rec (fromJust $ M.lookup bag rules)
  where
    rec (weight, next) = weight * (1 + cost next rules)

main :: IO ()
main =
  interact $
    show
      . cost "shiny gold"
      . M.fromList
      . map (bimap id parse . ltop . splitOn " bags contain " . trimSuffix ".")
      . lines
