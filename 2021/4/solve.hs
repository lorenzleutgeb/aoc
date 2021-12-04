{- stack script
 --resolver ghc-8.10.2
 --package split
 -}

import Data.List
import Data.List.Split as LS

marked = (== "X")

bingo :: [[String]] -> Bool
bingo board =
  any
    ( \i ->
        (all marked $ map (flip (!!) i) board)
          || (all marked $ board !! i)
    )
    [0 .. 4]

mark :: String -> [[[String]]] -> [[[String]]]
mark n = map (map (map (\x -> if x == n then "X" else x)))

pts :: [[String]] -> String -> Int
pts b x = (read x) * (sum $ map (sum . map read . filter (not . marked)) b)

p1 :: [String] -> [[[String]]] -> Int
p1 draw boards = go 0 boards
  where
    go i bs
      | null won = go (1 + i) $ mark (draw !! i) bs
      | otherwise = pts (head won) $ draw !! (i -1)
      where
        won = filter bingo bs

p2 :: [String] -> [[[String]]] -> Int
p2 draw boards = go 0 boards
  where
    go i bs
      | length bs == 1 && length won == 1 = pts (head won) $ draw !! (i -1)
      | otherwise =
        go
          (1 + i)
          ( if 1 + length won == length boards
              then filter (not . bingo) bs
              else mark (draw !! i) bs
          )
      where
        won = filter bingo bs

readBoards :: [String] -> [[String]]
readBoards (_ : ls) = map (LS.splitOn " ") $ map (replace "  " " ") $ map trim ls
  where
    trim (' ' : xs) = xs
    trim xs = xs
    replace old new = intercalate new . LS.splitOn old

main :: IO ()
main = do
  ns <- lines <$> getContents
  draw <- return $ LS.splitOn "," $ head ns
  boards <- return $ map readBoards $ LS.chunksOf 6 $ tail ns
  print $ p1 draw boards
  print $ p2 draw boards

-- Debugging
shob :: [[String]] -> String
shob b = (++) "\n\n" $ intercalate "\n" $ map (intercalate "\t") b
