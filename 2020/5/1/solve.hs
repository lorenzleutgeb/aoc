{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 -}

import Data.List
import Data.Maybe (fromJust, listToMaybe)
import Numeric (readInt)

data Row = F | B deriving (Enum, Read)

data Col = L | R deriving (Enum, Read)

readEnum :: Enum a => Int -> (String -> a) -> String -> Int
readEnum b f = fromJust . fmap fst . listToMaybe . readInt b (const True) (\y -> fromEnum $ f [y])

readRow :: String -> Int
readRow = readEnum 2 (read :: String -> Row)

readCol :: String -> Int
readCol = readEnum 2 (read :: String -> Col)

sid :: (Int, Int) -> Int
sid (r, c) = r * 8 + c

main :: IO ()
main =
  interact $
    show
      . maximum
      . map sid
      . map (\(r, c) -> (readRow r, readCol c))
      . map (splitAt 7)
      . lines
