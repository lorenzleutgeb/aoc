{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 -}

import Data.List
import Data.List.Split

main :: IO ()
main =
  interact $
    show
      . sum
      . map (length . foldl1 intersect . lines)
      . splitOn "\n\n"
