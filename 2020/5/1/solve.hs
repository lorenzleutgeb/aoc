{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 -}

import Data.List
import Data.Maybe (fromJust, listToMaybe)
import Numeric (readInt)

data Row = F | B deriving (Bounded, Enum, Read)

data Col = L | R deriving (Bounded, Enum, Read)

readEnum :: (Bounded a, Enum a) => a -> [a] -> Int
readEnum b = foldl' (\acc x -> acc * (1 + fromEnum b) + fromEnum x) 0

readRow :: [Row] -> Int
readRow = readEnum (maxBound :: Row)

readCol :: [Col] -> Int
readCol = readEnum (maxBound :: Col)

sid :: (Int, Int) -> Int
sid (r, c) = r * 8 + c

singleton :: a -> [a]
singleton a = [a]

main :: IO ()
main =
  interact $
    show
      . maximum
      . map sid
      . map (\(r, c) -> (readRow r, readCol c))
      . map (\(r, c) -> (map (read . singleton) r, map (read . singleton) c))
      . map (splitAt 7)
      . lines
