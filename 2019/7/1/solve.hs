{- stack script
 --resolver ghc-8.10.2
 -}
import Data.List       as L
import Data.List.Split as S
import Data.Vector     as V
import Debug.Trace (trace)

type Code = Vector Int

data Mode = Imm | Pos deriving (Show, Enum)

data Instruction = Add | Mul | In | Out | Jnz | Jz | Lt | Eq | Halt deriving Show

toInstruction :: Int -> Instruction
toInstruction  1 = Add
toInstruction  2 = Mul
toInstruction  3 = In
toInstruction  4 = Out
toInstruction  5 = Jnz
toInstruction  6 = Jz
toInstruction  7 = Lt
toInstruction  8 = Eq
toInstruction 99 = Halt
toInstruction  x = error ("unknown instruction " L.++ show x)

params Add  = (2, 1)
params Mul  = (2, 1)
params In   = (0, 1)
params Out  = (1, 0)
params Jz   = (2, 0)
params Jnz  = (2, 0)
params Lt   = (2, 1)
params Eq   = (2, 1)
params Halt = (0, 0)

write :: Code -> [Int] -> Int -> Int -> (Code, Maybe Int, Maybe Int, [Int])
write code is x c = (update code $ V.fromList [(c, x)], Nothing, Nothing, is)

exec :: Code -> [Int] -> Instruction -> [Int] -> [Int] -> (Code, Maybe Int, Maybe Int, [Int])
exec code is Add  [a, b] [c] = write code is (a + b) c
exec code is Mul  [a, b] [c] = write code is (a * b) c
exec code (i:is) In   []     [c] = write code is   i    c
exec code is Out  [0]    []  = (code, Nothing, Nothing, is)
exec code is Out  [x]    _   = trace ("out " L.++ (show x)) (code, Nothing, Just x, is)
exec code is Jz   [a, b] []  = (code, if a == 0 then Just b else Nothing, Nothing, is)
exec code is Jnz  [a, b] []  = (code, if a /= 0 then Just b else Nothing, Nothing, is)
exec code is Lt   [a, b] [c] = write code is (fromEnum $ a < b) c
exec code is Eq   [a, b] [c] = write code is (fromEnum $ a == b) c
exec code is Halt []     []  = (code, Nothing, Just (code!0), is)
exec _ _ _ _ _ = error "cannot exec"

indirect :: Code -> Mode -> Int -> Int
indirect code Imm parameter = parameter
indirect code Pos parameter = code!parameter

decode :: Int -> (Instruction, [Mode])
decode raw = (i, L.map toEnum ([raw `div` (10 ^ (j + 1)) `mod` 10 | j <- [1..fst $ params i]]))
  where i = toInstruction $ raw `mod` 100

run :: Int -> [Int] -> Code -> Int
run ptr inputs code = case halt of
    Just y -> y
    Nothing -> case maybeNextPtr of
      Nothing -> run (ptr + ins + outs + 1) nextIs nextCode
      Just x  -> run x nextIs nextCode
  where
  (instr, modes) = decode (code!ptr)
  (ins, outs) = (params instr)
  rawParams = [code!(ptr + j) | j <- [1..ins]]
  fetchedParams = L.zipWith (indirect code) modes rawParams
  target = [code!(ptr + ins + j) | j <- [1..outs]]
  (nextCode, maybeNextPtr, halt, nextIs) = exec code inputs instr fetchedParams target

parse :: String -> Code
parse = fromList . fmap read . S.splitOn ","

f :: Code -> Int -> Int -> Int
f code next phase = run 0 [phase, next] code

main = interact $ show . L.maximum . (\c -> L.map (L.foldl (f c) 0) (permutations [0..4])) . parse
