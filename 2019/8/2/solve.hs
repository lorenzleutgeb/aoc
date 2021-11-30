{- stack script
 --resolver ghc-8.10.2
 -}

import Data.Char (digitToInt)
import Data.List (intercalate)
import Data.List.Split (chunksOf)

width = 25

height = 6

data Color = Black | White | None deriving (Enum)

instance Show Color where
  show White = "\x2588"
  show _ = " "

merge None x = x
merge x _ = x

main =
  interact $
    intercalate "\n" . map (map (head . show)) . chunksOf width
      . foldl1 (zipWith merge)
      . chunksOf (width * height)
      . map (toEnum . digitToInt)
      . head
      . lines
