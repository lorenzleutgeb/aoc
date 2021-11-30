{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List (nub)

main =
  interact $
    show . maximum
      . map (length . nub . map ((\(x, y) -> let z = gcd x y in (div x z, div y z))))
      . (\as -> (\a -> [(fst b - fst a, snd b - snd a) | b <- as, b /= a]) <$> as)
      . (\input -> [(x, y) | (y, ln) <- index $ lines input, (x, '#') <- index ln])
  where
    index = zip [0 ..]
