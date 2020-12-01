{- stack script
 --resolver ghc-8.10.2
 -}

year = 2020

main = interact $ show . head
  . (\ns -> [n1 * n2 | n1 <- ns, n2 <- ns, n1 <= n2, n1 + n2 == year])
  . fmap read . lines
