{- stack script
 --resolver ghc-8.10.2
 -}
import Data.List       as L
import Data.List.Split as S
import Data.Maybe      as M
import Data.Vector     as V

op :: (Int -> Int -> Int) -> Int -> Vector Int -> Vector Int
op f ptr code = update code $ V.fromList [(code!(ptr + 3), (code!(code!(ptr + 1))) `f` (code!(code!(ptr + 2))))]

run :: Int -> Vector Int -> Int
run ptr code = case code!ptr of
  1 -> run (ptr + 4) $ op (+) ptr code
  2 -> run (ptr + 4) $ op (*) ptr code
  99 -> code!0
  _ -> error "Unknown opcode"

restore :: Vector Int -> (Int, Int) -> Vector Int
restore code (noun, verb) = update code $ V.fromList [(1, noun), (2, verb)]

combine (noun, verb) = 100 * noun + verb

goal :: Vector Int -> (Int, Int) -> Bool
goal code (noun, verb) = (==) 19690720 $ run 0 $ restore code (noun, verb)

match :: Vector Int -> (Int, Int)
match code = M.fromJust $ L.find (goal code) [(noun, verb) | noun <- [0..99], verb <- [0..99]]

main = interact $ show . combine . match . fromList . fmap read . S.splitOn ","
