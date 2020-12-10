{- stack script
 --resolver lts-16.24
 --package parsec
 --ghc-options -Wall
 -}

import Text.Parsec
import Text.Parsec.String

eitherError :: Show a => Either a b -> b
eitherError = either (error . show) id

type Input = ((Int, Int), Char, String)

check1 :: Input -> Bool
check1 (range, c, password) = let cnt = (length $ filter (c ==) password) in (fst range) <= cnt && cnt <= (snd range)

line :: Parser Input
line = do
  rangeMin <- many1 digit
  _ <- char '-'
  rangeMax <- many1 digit
  _ <- char ' '
  c <- letter
  _ <- string ": "
  password <- rest
  return ((read rangeMin, read rangeMax), c, password)

lf :: Char
lf = '\n'

rest :: Parser String
rest = many1 (noneOf [lf]) <* char lf

check2 :: Input -> Bool
check2 (range, c, password) = (password !! (fst range - 1) == c) /= (password !! (snd range - 1) == c)

main :: IO ()
main = do
  lines <- eitherError . parse (many line) "" <$> getContents
  print $ length $ filter check1 lines
  print $ length $ filter check2 lines
