{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 -}

import Data.Char
import Data.Ix
import Data.List.Split

default (Int)

fields :: [String]
fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

hasAllFields :: [(String, String)] -> Bool
hasAllFields s = all (\field -> any (\(fieldName, _) -> fieldName == field) s) fields

checkHeight :: (String, [Char]) -> Bool
checkHeight (x, "cm") = inRange (150, 193) $ read x
checkHeight (x, "in") = inRange (59, 76) $ read x
checkHeight _ = False

validField :: String -> String -> Bool
validField "byr" x = inRange (1920, 2002) $ read x
validField "iyr" x = inRange (2010, 2020) $ read x
validField "eyr" x = inRange (2020, 2030) $ read x
validField "hgt" x = checkHeight $ span isDigit x
validField "hcl" ('#' : color) = length color == 6 && all isHexDigit color
validField "ecl" "amb" = True
validField "ecl" "blu" = True
validField "ecl" "brn" = True
validField "ecl" "gry" = True
validField "ecl" "grn" = True
validField "ecl" "hzl" = True
validField "ecl" "oth" = True
validField "pid" x = length x == 9 && all isDigit x
validField "cid" _ = True
validField _ _ = False

replace :: Eq a => a -> a -> [a] -> [a]
replace x y = map (\z -> if x == z then y else z)

main :: IO ()
main =
  interact $
    show
      . length
      . filter (all (uncurry validField))
      . filter hasAllFields
      . (map . map) ((\[a, b] -> (a, b)) . splitOn ":")
      . map (lines . (replace ' ' '\n'))
      . splitOn "\n\n"
