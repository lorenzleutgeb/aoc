{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 --package split
 -}

import Data.Char
import qualified Data.IntMap as IM
import Data.List
import Data.List.Split
import qualified Data.Map as M

type Cache = Int

type Grid = (M.Map (Int, Int) Bool, (Cache, Cache, Cache, Cache))

type Tile = [Grid]

data Side = STop | SBot | SLeft | SRight deriving (Show, Eq, Ord)

type Constraint = (Side, Cache)

monster =
  concat
    [ [(r, c) | (c, char) <- zip [0 ..] row, char == '#']
      | (r, row) <- zip [0 ..] lines
    ]
  where
    lines =
      ["                  # ", "#    ##    ##    ###", " #  #  #  #  #  #   "]

sideLen = 10

tilesPerRow = 12

orientations g =
  [r (f g) | r <- [id, rotate], f <- [id, flipV, flipH, flipV . flipH]]

parseTile :: String -> (Int, Tile)
parseTile input = (tileId, positions)
  where
    (head : rest) = lines input
    tileId = read $ takeWhile isDigit $ drop 5 head
    grid =
      M.fromList $
        concat
          [ [((r, c), char == '#') | (c, char) <- zip [0 ..] row]
            | (r, row) <- zip [0 ..] rest
          ]
    toNum = foldl (\acc b -> acc * 2 + (if b then 1 else 0)) 0
    makeSide side g = toNum $ calcSide side g
    positions :: [Grid]
    positions =
      [ ( g,
          (makeSide STop g, makeSide SBot g, makeSide SLeft g, makeSide SRight g)
        )
        | g <- orientations grid
      ]

parse :: String -> IM.IntMap Tile
parse = IM.fromList . map parseTile . splitOn "\n\n"

calcSide STop grid = [grid M.! (0, c) | c <- [0 .. sideLen - 1]]
calcSide SBot grid = [grid M.! (sideLen - 1, c) | c <- [0 .. sideLen - 1]]
calcSide SLeft grid = [grid M.! (r, 0) | r <- [0 .. sideLen - 1]]
calcSide SRight grid = [grid M.! (r, sideLen - 1) | r <- [0 .. sideLen - 1]]

maxCoord :: M.Map (Int, Int) a -> Int
maxCoord grid = dim where Just ((dim, _), _) = M.lookupMax grid

flipV grid = M.mapWithKey (\(r, c) _ -> grid M.! (maxCoord grid - r, c)) grid

flipH grid = M.mapWithKey (\(r, c) _ -> grid M.! (r, maxCoord grid - c)) grid

rotate grid = M.mapWithKey (\(r, c) _ -> grid M.! (maxCoord grid - c, r)) grid

render grid =
  intercalate
    "\n"
    [ [if grid M.! (r, c) then '#' else '.' | c <- [0 .. cmax]]
      | r <- [0 .. rmax]
    ]
  where
    Just ((rmax, cmax), _) = M.lookupMax grid

match :: [Constraint] -> Tile -> [Grid]
match constraints =
  filter (\t -> all (\(side, vals) -> getSide side t == vals) constraints)

getSide STop (_, (s, _, _, _)) = s
getSide SBot (_, (_, s, _, _)) = s
getSide SLeft (_, (_, _, s, _)) = s
getSide SRight (_, (_, _, _, s)) = s

solve ::
  M.Map (Int, Int) (Int, Grid) ->
  IM.IntMap Tile ->
  (Int, Int) ->
  [M.Map (Int, Int) (Int, Grid)]
solve placed bag (r, c)
  | IM.null bag = [placed]
  | otherwise = do
    (tileId, tile) <- IM.assocs bag
    placement <- match (getConstraints placed (r, c)) tile
    solve
      (M.insert (r, c) (tileId, placement) placed)
      (IM.delete tileId bag)
      (next (r, c))
  where
    next (r, c) = if c == tilesPerRow - 1 then (r + 1, 0) else (r, c + 1)
    getConstraints :: M.Map (Int, Int) (Int, Grid) -> (Int, Int) -> [Constraint]
    getConstraints _ (0, 0) = []
    getConstraints placed (0, c) =
      [(SLeft, getSide SRight (snd $ placed M.! (r, c - 1)))]
    getConstraints placed (r, 0) =
      [(STop, getSide SBot (snd $ placed M.! (r - 1, c)))]
    getConstraints placed (r, c) =
      [ (SLeft, getSide SRight (snd $ placed M.! (r, c - 1))),
        (STop, getSide SBot (snd $ placed M.! (r - 1, c)))
      ]

trimEdges :: M.Map (Int, Int) Bool -> M.Map (Int, Int) Bool
trimEdges grid =
  M.mapKeysMonotonic (\(r, c) -> (r - 1, c - 1)) $
    M.filterWithKey
      (\(r, c) _ -> 1 <= r && r < sideLen - 1 && 1 <= c && c < sideLen - 1)
      grid

makePicture ::
  M.Map (Int, Int) (M.Map (Int, Int) Bool) -> M.Map (Int, Int) Bool
makePicture soln =
  M.fromList
    [ ((r, c), b)
      | r <- [0 .. dim - 1],
        c <- [0 .. dim - 1],
        let b =
              soln
                M.! (r `div` (sideLen - 2), c `div` (sideLen - 2))
                M.! (r `mod` (sideLen - 2), c `mod` (sideLen - 2))
    ]
  where
    dim = (sideLen - 2) * tilesPerRow

countMonsters grid =
  length
    [ (r, c)
      | r <- [0 .. maxCoord grid],
        c <- [0 .. maxCoord grid],
        isMonster (r, c)
    ]
  where
    isMonster (r, c) =
      all (\(dr, dc) -> Just True == grid M.!? (r + dr, c + dc)) monster

part1 tiles =
  product
    [soln M.! (r, c) | r <- [0, tilesPerRow - 1], c <- [0, tilesPerRow - 1]]
  where
    soln = M.map fst $ head $ solve M.empty tiles (0, 0)

part2 tiles =
  total - length monster
    * maximum
      [found | g <- orientations pic, let found = countMonsters g, found > 0]
  where
    soln = M.map (trimEdges . fst . snd) $ head $ solve M.empty tiles (0, 0)
    pic = makePicture soln
    total = M.size $ M.filter id pic

main = do
  putStrLn "Day 20"
  tiles <- parse <$> readFile "input.txt"
  print $ part1 tiles
  print $ part2 tiles
