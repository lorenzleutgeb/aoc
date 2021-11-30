{- stack script
 --resolver lts-16.24
 --ghc-options -Wall
 --package containers
 -}

import Data.List (intercalate, sort)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Text.ParserCombinators.ReadP

parse :: String -> [(S.Set String, S.Set String)]
parse = fst . head . readP_to_S ((sepBy line (char '\n')) <* skipSpaces <* eof)
  where
    word = many1 $ satisfy (`notElem` ", ")
    line =
      (,)
        <$> (S.fromList <$> many1 (word <* char ' '))
        <*> ( S.fromList
                <$> between
                  (string "(contains ")
                  (char ')')
                  (sepBy1 word (string ", "))
            )

mapify :: [(S.Set String, S.Set String)] -> M.Map String (S.Set String)
mapify = go M.empty
  where
    go m ((ings, alls) : rest) =
      go
        (S.foldr (\s -> M.insertWith S.intersection s ings) m alls)
        rest
    go m [] = m

solve :: M.Map String (S.Set String) -> [(String, String)]
solve m = case M.lookupMin (M.filter (S.null . S.drop 1) m) of
  Just (all, ings) ->
    let ing = S.findMin ings
     in (all, ing) : solve (M.map (S.delete ing) $ M.delete all m)
  Nothing -> []

solve1 :: [(String, String)] -> [(S.Set String, S.Set String)] -> Int
solve1 y x = go $ S.fromList $ map snd y
  where
    go s = sum $ map (S.size . (S.\\ s) . fst) x

solve2 :: [(String, String)] -> String
solve2 = intercalate "," . map snd . sort

main :: IO ()
main = do
  input <- parse <$> getContents
  let solvedInput = solve . mapify $ input
  print $ solve1 solvedInput input
  putStrLn $ solve2 solvedInput
