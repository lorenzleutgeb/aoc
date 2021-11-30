{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 -}

import Data.List
import Data.Maybe (fromJust, listToMaybe)
import Numeric (readInt)

data Row = F | B deriving (Bounded, Enum, Read)

data Col = L | R deriving (Bounded, Enum, Read)

readEnum :: Enum a => Int -> (String -> a) -> String -> Int
readEnum b f = foldl' (\acc x -> acc * b + (fromEnum . f) [x]) 0

readRow :: String -> Int
readRow = readEnum 2 (read :: String -> Row)

readCol :: String -> Int
readCol = readEnum 2 (read :: String -> Col)

sid :: (Int, Int) -> Int
sid (r, c) = r * 8 + c

fd [x] = x
fd (x1 : (x2 : xs)) = if x1 + 1 == x2 then fd (x2 : xs) else x2

main :: IO ()
main =
  interact $
    show
      . fd
      . map sid
      . (\xs -> [(r, c) | r <- [0 .. 127], c <- [0 .. 7], not ((r, c) `elem` xs)])
      . map (\(r, c) -> (readRow r, readCol c))
      . map (splitAt 7)
      . lines
