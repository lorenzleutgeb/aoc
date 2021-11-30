{- stack script
 --resolver ghc-8.10.2
 -}

{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE ViewPatterns #-}

import Data.Char (digitToInt)
import Data.Function (on)
import Data.List (delete, groupBy, intercalate, maximumBy, nub, sortBy)
import Data.List.Split (chunksOf)
import Data.Ord (comparing)
import Data.Ratio (denominator, numerator, (%))
import Debug.Trace (trace)

-- http://mathworld.wolfram.com/FareySequence.html
farey a b
  | da2 <= 10 ^ 6 = farey a1 b
  | otherwise = na
  where
    na = numerator a
    nb = numerator b
    da = denominator a
    db = denominator b
    a1 = (na + nb) % (da + db)
    da2 = denominator a1

pattern num :% denom <- ((\x -> (numerator x, denominator x)) -> (num, denom))

data Position = Empty | Asteroid deriving (Enum, Eq)

type Coordinate = (Int, Int)

type AsteroidField = [Coordinate]

type Angle = Double

instance Show Position where
  show Empty = "."
  show Asteroid = "#"

parse "." = Empty
parse "#" = Asteroid

bestCoordinate :: AsteroidField -> Coordinate
bestCoordinate asteroids = maximumBy (comparing $ length . asteroidClassesForCoordinate asteroids) $ asteroids

asteroidClassesForCoordinate :: AsteroidField -> Coordinate -> [[Coordinate]]
asteroidClassesForCoordinate asteroids p = equivs (angle p) $ delete p $ asteroids

distance :: Coordinate -> Coordinate -> Double
distance (a, b) (x, y) = sqrt $ fromIntegral $ ((+) `on` (^ 2)) (a - x) (b - y)

angle :: Coordinate -> Coordinate -> Angle
angle (x, y) (a, b) = pi - (atan2 (fromIntegral $ a - x) (fromIntegral $ b - y))

equivs :: Ord b => (a -> b) -> [a] -> [[a]]
equivs f = groupBy ((==) `on` f) . sortBy (comparing f)

flatten :: [[a]] -> [a]
flatten xs = (\z n -> foldr (\x y -> foldr z y x) n xs) (:) []

-- 1. Find the best location (like for Part 1).
-- 1.a. Relativize coordinates such that the best location gets (0, 0),
--      but save to de-relativize later.
-- 2. Take all (other) asteroids and group them by angle.
--    This can be done by taking the atan2
-- 3. For all angles, group the elements by distance.
--    This

--  asteroids <- readAsteroids
--  let laserPos = bestPosition asteroids
--  let classes = fmap (sortBy (comparing (distance laserPos)))
--              $ sortBy (comparing (angle laserPos . head))
--              $ asteroidClassesForPosition asteroids laserPos
--  return $ (\(x, y) -> 100*x + y) $ shoot 200 classes

main =
  interact $
    show
      . (\(x, y, bs) -> length bs)
      . maximumBy (\(x, y, bs) (x', y', bs') -> compare (length bs) (length bs'))
      . map (\(x, y, bs) -> (x, y, nub bs))
      -- . map (\(x, y, bs) -> (x, y, map (\(x, y) -> atan2 (fromIntegral x) (fromIntegral y)) bs))
      . map (\(x, y, bs) -> (x, y, map (\(x :% y) -> let z = gcd x y in (x `div` z, y `div` z)) bs))
      . (\as -> map (\(ax, ay) -> (ax, ay, [(bx - ax) % (by - ay) | (bx, by) <- as, bx /= ax || by /= ay])) as)
      . map fst
      . filter (\((_, _), x) -> x == Asteroid)
      . zipWith (\y l -> fmap (\(x, c) -> ((x, y), parse [c])) l) [0 ..]
      . lines
