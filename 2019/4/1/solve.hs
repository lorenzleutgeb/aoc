import Data.List

main = putStrLn $ show . length
  . filter (any ((<=) 2 . length) . group)
  . filter (\xs -> and $ zipWith (<=) xs (tail xs))
  . map show $ [231832..767346]
