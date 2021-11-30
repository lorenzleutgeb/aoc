{- stack script
 --resolver ghc-8.10.2
 -}

import Data.Function (on)
import Data.List (transpose)

gravity :: Num a => [(a, a)] -> [a]
gravity xs = (\x -> sum $ (\x' -> signum $ ((-) `on` fst) x' x) <$> xs) <$> xs

step :: Num a => [(a, a)] -> [(a, a)]
step bs = zipWith (\(p, v) g -> (p + v + g, v + g)) bs (gravity bs)

energy :: Num a => [a] -> [a] -> a
energy ps vs = ((*) `on` sum . map abs) ps vs

main =
  putStrLn $
    show $
      (\x -> sum [energy ps vs | (ps, vs) <- unzip <$> x]) $
        transpose $
          (\d -> iterate step d !! 1000) <$> bs
  where
    bs =
      transpose $
        (\(x, y, z) -> [(x, 0), (y, 0), (z, 0)])
          <$> [ (7, 10, 17),
                (- 2, 7, 0),
                (12, 5, 12),
                (5, - 8, 6)
              ]
