{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package split
 -}

import Data.Bifunctor
import Data.List
import Data.List.Split

data Instr = Acc | Jmp | Nop

parseInstr :: String -> Instr
parseInstr "acc" = Acc
parseInstr "jmp" = Jmp
parseInstr "nop" = Nop
parseInstr _ = error "Cannot parse instruction"

ltop :: [a] -> (a, a)
ltop [x, y] = (x, y)
ltop _ = error "Can ony convert list with exactly two elements to pair"

trimPrefix :: Eq a => [a] -> [a] -> [a]
trimPrefix xs ys = case stripPrefix xs ys of
  Nothing -> ys
  Just zs -> zs

parse :: String -> (Instr, Int)
parse s = bimap parseInstr (read . trimPrefix "+") $ ltop $ (splitOn " " s)

run :: [(Instr, Int)] -> Int -> Int -> [Int] -> Int
run code state ip history
  | ip `elem` history = state
  | ip' == length code = state'
  | otherwise = run code state' ip' history'
  where
    curr = code !! ip
    (state', ip') = runSingle curr state ip
    history' = ip : history

runSingle :: Num a => (Instr, a) -> a -> a -> (a, a)
runSingle (Acc, x) state ip = (state + x, ip + 1)
runSingle (Jmp, x) state ip = (state, ip + x)
runSingle (Nop, _) state ip = (state, ip + 1)

main :: IO ()
main = interact $
  show
  . (\code -> run code 0 0 [])
  . map parse
  . lines
