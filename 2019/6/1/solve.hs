{- stack script
 --resolver ghc-8.10.2
 -}
import           Data.List.Split       (splitOn)
import qualified Data.MultiMap   as MM (fromList, lookup)

ltop [x, y] = (x, y)

orbits n a mm = n + sum (map (\b -> orbits (n + 1) b mm) $ MM.lookup a mm)

main = interact $ show . orbits 0 "COM" . MM.fromList . map (ltop . splitOn ")") . lines
