{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 -}

import Data.IntMap.Strict (IntMap, findMax, fromList, union, (!))

input :: [Int]
input = [1, 8, 6, 5, 2, 4, 9, 7, 3]

type Circle = (Int, IntMap Int)

parse :: [Int] -> Circle
parse =
  (,)
    <$> head
    <*> (fromList . (zip <$> id <*> ((++) <$> tail <*> (: []) . head)))

move :: Circle -> Circle
move (c, ls) = (next, (fromList [(c, next), (dest, c1), (c3, ls ! dest)]) `union` ls)
  where
    c1 = ls ! c
    c2 = ls ! c1
    c3 = ls ! c2
    next = ls ! c3
    (wrap, _) = findMax ls
    desc = [c -1, c -2 .. 1] ++ [wrap, wrap -1 ..]
    dest = head $ filter (`notElem` [c1, c2, c3]) desc

unparse :: Circle -> String
unparse (_, labels) = go (labels ! 1)
  where
    go 1 = ""
    go c = show c ++ go (labels ! c)

p1 :: Circle -> Int
p1 circle = read $ unparse $ iterate move circle !! 100

p2 :: Circle -> Int
p2 circle = c1 * c2
  where
    (_, ls) = iterate move circle !! 10000000
    c1 = ls ! 1
    c2 = ls ! c1

main :: IO ()
main = do
  print $ p1 (parse input)
  print $ p2 (parse $ input ++ [10 .. 1000000])
