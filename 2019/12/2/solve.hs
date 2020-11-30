{- stack script
 --resolver ghc-8.10.2
 -}
import Data.Function   (on)
import Data.List       (elemIndex, transpose)
import Data.Maybe      (catMaybes)

gravity :: [(Int, Int)] -> [Int]
gravity xs = (\x -> sum $ (\x' -> signum $ ((-) `on` fst) x' x) <$> xs) <$> xs

step :: [(Int, Int)] -> [(Int, Int)]
step bs = zipWith (\(p, v) g -> (p + v + g, v + g)) bs (gravity bs)

main = putStrLn $ show
    . foldr (lcm . succ) 1 . catMaybes
    $ zipWith (elemIndex) bs
    $ tail . iterate step <$> bs
    where
      bs = transpose $ (\(x, y, z) -> [(x, 0), (y, 0), (z, 0)]) <$> [
        (  7,  10,  17),
        (- 2,   7,   0),
        ( 12,   5,  12),
        (  5, - 8,   6)
        ]
