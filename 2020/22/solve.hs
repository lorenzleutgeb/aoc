{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 --package dequeue
 --package split
 -}

import Data.Dequeue
import Data.List (intercalate, sort)
import Data.List.Split
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Text.ParserCombinators.ReadP

mapify :: [(S.Set String, S.Set String)] -> M.Map String (S.Set String)
mapify = go M.empty
  where
    go m ((ings, alls) : rest) =
      go
        (S.foldr (\s -> M.insertWith S.intersection s ings) m alls)
        rest
    go m [] = m

solve :: M.Map String (S.Set String) -> [(String, String)]
solve m = case M.lookupMin (M.filter (S.null . S.drop 1) m) of
  Just (all, ings) ->
    let ing = S.findMin ings
     in (all, ing) : solve (M.map (S.delete ing) $ M.delete all m)
  Nothing -> []

solve1 :: [(String, String)] -> [(S.Set String, S.Set String)] -> Int
solve1 y x = go $ S.fromList $ map snd y
  where
    go s = sum $ map (S.size . (S.\\ s) . fst) x

solve2 :: [(String, String)] -> String
solve2 = intercalate "," . map snd . sort

ltop [x, y] = (x, y)

turn q1 q2 =
  if n1' > n2'
    then (pushBack n2' q1, q2')
    else (q1', pushBack n2' q2)
  where
    (n1, q1') = popFront q1
    (n2, q2') = popFront q2
    n1' = fromJust n1
    n2' = fromJust n2

won :: (BankersDequeue Int) -> (BankersDequeue Int) -> (Maybe (BankersDequeue Int))
won q1 q2 = if empty q1 then Just q2 else if empty q2 then Just q1 else Nothing

parse :: String -> ([Int], [Int])
parse = ltop . map map read . map tail . splitBy "\n\n"

main :: IO ()
main = do
  input <- parse <$> getContents
  let solvedInput = solve . mapify $ input
  print $ solve1 solvedInput input
  putStrLn $ solve2 solvedInput
