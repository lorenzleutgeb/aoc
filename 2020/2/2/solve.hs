{- stack script
 --resolver lts-16.24
 --package parsec
 --ghc-options -Wall
 -}

import Text.Parsec
import Text.Parsec.String

main :: IO ()
main =
  interact $
    show
      . length
      . filter check
      . eitherError
      . parse (many line) ""

eitherError :: Show a => Either a b -> b
eitherError = either (error . show) id

type Input = ((Int, Int), Char, String)

check :: Input -> Bool
check (range, c, password) = (password !! (fst range - 1) == c) /= (password !! (snd range - 1) == c)

line :: Parser Input
line = do
  rangeMin <- many1 digit
  _ <- char '-'
  rangeMax <- many1 digit
  _ <- char ' '
  c <- letter
  _ <- string ": "
  password <- rest
  return $ ((read rangeMin, read rangeMax), c, password)

lf :: Char
lf = '\n'

rest :: Parser String
rest = many1 (noneOf [lf]) <* char lf
