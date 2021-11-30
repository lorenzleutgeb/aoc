{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List.Split (splitOn)
import qualified Data.Map as M (fromList, lookup)
import Data.Maybe (fromJust)

ltop [x, y] = (x, y)

pathTo "COM" m = []
pathTo a m = a : pathTo (fromJust $ M.lookup a m) m

dropWhilePrefix (x : as) (y : bs)
  | x == y = dropWhilePrefix as bs
  | otherwise = (as, bs)

distance m = length a + length b
  where
    (a, b) = dropWhilePrefix (reverse $ pathTo "SAN" m) (reverse $ pathTo "YOU" m)

main = interact $ show . distance . M.fromList . map (ltop . reverse . splitOn ")") . lines
