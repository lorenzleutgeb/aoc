{- stack script
 --resolver ghc-8.10.2
 -}
import Data.List       as L
import Data.List.Split as S
import Data.Vector     as V
import Debug.Trace (trace)

type Code = Vector Int

data Mode = Imm | Pos deriving Show

toMode 0 = Pos
toMode 1 = Imm
toMode _ = error "unknown mode"

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

write :: Code -> Int -> Int -> (Code, Maybe Int, Bool)
write code x c = (update code $ V.fromList [(c, x)], Nothing, False)

exec :: Code -> Instruction -> [Int] -> [Int] -> (Code, Maybe Int, Bool)
exec code Add  [a, b] [c] = write code (a + b) c
exec code Mul  [a, b] [c] = write code (a * b) c
exec code In   []     [c] = write code    5    c
exec code Out  [0]    []  = (code, Nothing, False)
exec code Out  [x]    _   = trace ("out " L.++ (show x)) (code, Nothing, False)
exec code Jz   [a, b] []  = (code, if a == 0 then Just b else Nothing, False)
exec code Jnz  [a, b] []  = (code, if a /= 0 then Just b else Nothing, False)
exec code Lt   [a, b] [c] = write code (fromEnum $ a < b) c
exec code Eq   [a, b] [c] = write code (fromEnum $ a == b) c
exec code Halt []     []  = (code, Nothing, True)
exec _ _ _ _ = error "cannot exec"

indirect :: Code -> Mode -> Int -> Int
indirect code Imm parameter = parameter
indirect code Pos parameter = code!parameter

decode :: Int -> (Instruction, [Mode])
decode raw = (i, L.map toMode ([raw `div` (10 ^ (j + 1)) `mod` 10 | j <- [1..fst $ params i]]))
  where i = toInstruction $ raw `mod` 100

run :: Int -> Code -> Int
run ptr code = if halt
    then nextCode!0
    else case maybeNextPtr of
      Nothing -> run (ptr + ins + outs + 1) nextCode
      Just x  -> run x nextCode
  where
  (instr, modes) = decode (code!ptr)
  (ins, outs) = (params instr)
  rawParams = [code!(ptr + j) | j <- [1..ins]]
  fetchedParams = L.zipWith (indirect code) modes rawParams
  target = [code!(ptr + ins + j) | j <- [1..outs]]
  (nextCode, maybeNextPtr, halt) = exec code instr fetchedParams target

main = interact $ show . run 0 . fromList . fmap read . S.splitOn ","
