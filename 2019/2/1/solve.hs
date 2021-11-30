{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List.Split
import Data.Vector

op :: (Int -> Int -> Int) -> Int -> Vector Int -> Vector Int
op f ptr code = update code $ V.fromList [(code ! (ptr + 3), (code ! (code ! (ptr + 1))) `f` (code ! (code ! (ptr + 2))))]

run :: Int -> Vector Int -> Int
run ptr code = case code ! ptr of
  1 -> run (ptr + 4) $ op (+) ptr code
  2 -> run (ptr + 4) $ op (*) ptr code
  99 -> code ! 0
  _ -> error "Unknown opcode"

restore :: Vector Int -> Vector Int
restore code = update code (fromList [(1, 12), (2, 2)])

main = interact (show . run 0 . restore . fromList . fmap read . splitOn ",")
