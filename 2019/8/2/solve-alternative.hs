{- stack script
 --resolver ghc-8.10.2
 -}

import Data.Char (digitToInt)
import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)

width = 25

height = 6

data Color = Black | White | None deriving (Enum)

instance Semigroup Color where
  None <> x = x
  x <> _ = x

instance Monoid Color where
  mempty = None

instance Show Color where
  show White = "\x2588"
  show _ = " "

main =
  interact $
    intercalate "\n" . map (map (head . show)) . chunksOf width
      . map mconcat
      . transpose
      . chunksOf (width * height)
      . map ((toEnum :: Int -> Color) . digitToInt)
      . head
      . lines
