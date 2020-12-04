{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 -}

import Data.List
import Data.List.Split

fields = map (flip (++) $ ":") ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

main :: IO ()
main =
  interact $
    show
      . length
      . filter (\x -> all (flip isInfixOf $ x) fields)
      . splitOn "\n\n"
