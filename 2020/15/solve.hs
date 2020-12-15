{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 --package lens
 -}

import Control.Lens
import Data.IntMap

run :: [Int] -> [Int]
run ns =
  (++) ns $
    fmap (view _2) $
      iterate
        (\(tab, prev, i) -> (insert prev i tab, maybe 0 ((-) i) (tab !? prev), i + 1))
        (fromList $ zip (init ns) [0 ..], last ns, length ns - 1)

main :: IO ()
main = do
  let ns = [11, 18, 0, 20, 1, 7, 16]
  print $ (run ns) !! 2020
  print $ (run ns) !! 30000000
