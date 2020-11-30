{- stack script
 --resolver ghc-8.10.2
 -}
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

-- Constructs initial requirements for fuel.
fuel :: Requirements
fuel = M.singleton "FUEL" 1

-- Extracts the ore requirements from otherwise
-- completely reduced requirements.
ore :: Requirements -> Amount
ore m | M.size m' == 1, Just amount <- m' M.!? "ORE" = amount
      | otherwise = error "no ORE required, or other requirements left"
      where
        m' = M.filterWithKey (\k a -> k == "ORE" || a > 0) m

solve :: Reactions -> Amount
solve reactions = ore $ hammer (produceAndReduce reactions) fuel

main = interact $ show . solve . M.fromList . map parse . lines
