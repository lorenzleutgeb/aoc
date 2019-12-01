fuel mass = (div mass 3) - 2

main = interact (show . sum . fmap (fuel . read) . lines)
