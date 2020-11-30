{- stack script
 --resolver ghc-8.10.2
 -}

fuel mass = (div mass 3) - 2

main = interact (show . sum . fmap (fuel . read) . lines)
