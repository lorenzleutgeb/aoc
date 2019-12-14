{-# LANGUAGE LambdaCase #-}

import           Data.List.Split      (dropBlanks, split, dropDelims, oneOf)
import qualified Data.Map        as M

type Chemical = String
type Amount   = Integer

type Reaction = (Chemical, ([(Chemical, Amount)], Amount))

-- Maps from the name of a chemical to a tuple that holds
-- how much of that chemical can be produced per unit and
-- what the requirements per unit are.
type Reactions = M.Map Chemical ([(Chemical, Amount)], Amount)

-- Working memory to keep track of how much of which
-- chemical is still needed.
type Requirements = M.Map Chemical Amount

parse :: String -> Reaction
parse s = (fst result, (init splits, snd result))
  where
    splitter = dropBlanks $ dropDelims $ oneOf "=>,"
    splits   = (\case [amount, chemical] -> (chemical, read amount))
               <$> words
               <$> split splitter s
    result   = last splits

produceAndReduce :: Reactions -> Requirements -> Requirements
produceAndReduce reactions = foldr (M.unionWith (+)) M.empty .
                             map (M.fromList . produce reactions) .
                             M.toList

produce reactions (chemical, amount)
  | amount > 0
  , Just (requiredChemicals, producable) <- reactions M.!? chemical
    = let (times, leftover) = reactionCount amount producable in
      (chemical, -leftover) : (
        (\(requiredChemical, requiredAmount) -> (requiredChemical, requiredAmount * times))
          <$>
        requiredChemicals
      )
  | amount ==0
    = []
  | otherwise
    = [(chemical, amount)]

reactionCount required producible
  | leftover > 0 = (times + 1, producible - leftover)
  | leftover ==0 = (times    ,          0           )
  where (times, leftover) = divMod required producible

-- Computes a fixed point of a closed operation.
hammer :: Eq a => (a -> a) -> a -> a
hammer f x
  | x' == x   = x'
  | otherwise = hammer f x'
  where x' = f x

-- Constructs initial requirements for a
-- certain amount of fuel.
fuel :: Amount -> Requirements
fuel = M.singleton "FUEL"

-- Extracts the ore requirements from otherwise
-- completely reduced requirements.
ore :: Requirements -> Amount
ore m | M.size m' == 1, Just amount <- m' M.!? "ORE" = amount
      | otherwise = error "no ORE required, or other requirements left"
      where
        m' = M.filterWithKey (\k a -> k == "ORE" || a > 0) m

solve :: Reactions -> Amount -> Amount
solve reactions amount = ore $ hammer (produceAndReduce reactions) $ fuel amount

binarySearchWith :: Integral a => a -> a -> (a -> b) -> (b -> Ordering) -> Either (a, a) a
binarySearchWith minBound maxBound f cmp
  | maxBound < minBound = Left (minBound, maxBound)
  | otherwise           = let middle = div (minBound + maxBound) 2 in
                          case cmp $ f middle of
                            LT -> binarySearchWith minBound (middle - 1) f cmp
                            EQ -> Right middle
                            GT -> binarySearchWith (middle + 1) maxBound f cmp

binarySearch :: (Integral a, Ord b) => a -> a -> (a -> b) -> b -> Either (a, a) a
binarySearch minBound maxBound f needle = binarySearchWith minBound maxBound f (compare needle)

binarySearchClosedMax :: (Integral a) => a -> a -> (a -> a) -> Either (a, a) a
binarySearchClosedMax minBound maxBound f = binarySearch minBound maxBound f maxBound

toIndex :: Integral a => Either (a, a) a -> a
toIndex (Left (x, y)) = div (x + y) 2
toIndex (Right x    ) = x

trillion = 10 ^ 12

main = interact $ show . toIndex
  . (\m -> binarySearchClosedMax 1 trillion $ solve m)
  . M.fromList . map parse . lines
