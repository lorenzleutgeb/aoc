import Data.Function   (on)
import Data.List       (minimumBy)
import Data.List.Split (chunksOf)
import Data.List.Utils (countElem)

main = interact $ show
  . (\x -> countElem 1 x * countElem 2 x)
  . minimumBy (compare `on` (countElem 0))
  . chunksOf (25 * 6) . map (read . (:[])) . head . lines
