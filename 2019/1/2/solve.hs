{- stack script
 --resolver ghc-8.10.2
 -}
fuel mass = if x <= 0 then 0 else x + fuel x where x = (div mass 3) - 2

main = interact (show . sum . fmap (fuel . read) . lines)
