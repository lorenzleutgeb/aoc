{- stack script
 --resolver ghc-8.10.2
 -}

year = 2020

p1 :: [Int] -> Int
p1 ns = head $ [n1 * n2 | n1 <- ns, n2 <- ns, n1 <= n2, n1 + n2 == year]

p2 :: [Int] -> Int
p2 ns = head $ [n1 * n2 * n3 | n1 <- ns, n2 <- ns, n3 <- ns, n1 <= n2, n2 <= n3, n1 + n2 + n3 == year]

main :: IO ()
main = do
  ns <- map read . lines <$> getContents
  print $ p1 ns
  print $ p2 ns
