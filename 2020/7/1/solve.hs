{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 -}

import Data.Bifunctor
import Data.Char
import Data.List
import Data.List.Split

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

converge :: Eq a => (a -> a) -> a -> a
converge = until =<< ((==) =<<)

containers :: [(String, [(Int, String)])] -> [String] -> [String]
containers rules goals = nub $ goals ++ (foldl union [] $ map direct goals)
  where
    direct to = map fst $ filter (any ((==) to . snd) . snd) rules

main :: IO ()
main =
  interact $
    show
      . flip (-) 1
      . length
      . (\rules -> converge (containers rules) ["shiny gold"])
      . map (bimap id parse . ltop . splitOn " bags contain " . trimSuffix ".")
      . lines
