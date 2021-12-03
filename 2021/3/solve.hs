{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List

bin :: [Int] -> Int
bin xs = go (reverse xs) 0
  where
    go [] _ = 0
    go (1 : xs) n = go xs (n + 1) + (2 ^ n)
    go (0 : xs) n = go xs (n + 1)
    go _ _ = error "bin only defined on lists with x == 1 or x == 0 for all list elements x"

count :: Eq a => a -> [a] -> Int
count x = length . filter (== x)

-- Short notation.
c0 :: String -> Int
c0 = count '0'

-- Short notation.
c1 :: String -> Int
c1 = count '1'

p1 :: [String] -> Int
p1 ls = (bin $ map ε ls) * (bin $ map γ ls)
  where
    x l = c0 l > c1 l
    ε l = if x l then 1 else 0
    γ l = if x l then 0 else 1

criteria :: (Int -> Int -> Bool) -> [String] -> String
criteria op ls = go ls 0
  where
    go [x] _ = x
    go xs i = go (filter (\n -> n !! i == y) xs) (i + 1)
      where
        -- Projection of the i-th "column", i.e. the i-th digit of
        -- every number in xs.
        π = map (flip (!!) i) xs
        y = if c0 π `op` c1 π then '1' else '0'

o2 :: [String] -> String
o2 = criteria (<=)

co2 :: [String] -> String
co2 = criteria (>)

readChars :: Read a => String -> [a]
readChars = map (read . (: []))

p2 :: [String] -> Int
p2 ls = (bin $ readChars $ o2 ls) * (bin $ readChars $ co2 ls)

main :: IO ()
main = do
  ns <- lines <$> getContents
  print $ p1 (transpose ns)
  print $ p2 ns
