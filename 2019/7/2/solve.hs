{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List as L
import Data.List.Split as S
import Data.Vector as V
import Debug.Trace (trace)

type Code = Vector Int

data Flow = Halted Int | Jump Int | Suspend | Continue

data Inactive = Resulted Int | Suspended Int | Waiting Int

data Mode = Imm | Pos deriving (Enum, Show)

data Instruction = Add | Mul | In | Out | Jnz | Jz | Lt | Eq | Halt deriving (Show)

toInstruction :: Int -> Instruction
toInstruction 1 = Add
toInstruction 2 = Mul
toInstruction 3 = In
toInstruction 4 = Out
toInstruction 5 = Jnz
toInstruction 6 = Jz
toInstruction 7 = Lt
toInstruction 8 = Eq
toInstruction 99 = Halt
toInstruction x = error ("unknown instruction " L.++ show x)

params Add = (2, 1)
params Mul = (2, 1)
params In = (0, 1)
params Out = (1, 0)
params Jz = (2, 0)
params Jnz = (2, 0)
params Lt = (2, 1)
params Eq = (2, 1)
params Halt = (0, 0)

write :: Code -> [Int] -> Int -> Int -> (Code, Flow, [Int])
write code is x c = (update code $ V.fromList [(c, x)], Continue, is)

exec :: Code -> [Int] -> Instruction -> [Int] -> [Int] -> (Code, Flow, [Int])
exec code is Add [a, b] [c] = write code is (a + b) c
exec code is Mul [a, b] [c] = write code is (a * b) c
exec code (i : is) In [] [c] = trace (" in " L.++ (show i)) (write code is i c)
exec code is Out [x] _ = trace ("out " L.++ (show x)) (code, Suspend, is L.++ [x])
exec code is Jz [a, b] [] = (code, if a == 0 then Jump b else Continue, is)
exec code is Jnz [a, b] [] = (code, if a /= 0 then Jump b else Continue, is)
exec code is Lt [a, b] [c] = write code is (fromEnum $ a < b) c
exec code is Eq [a, b] [c] = write code is (fromEnum $ a == b) c
exec code is Halt [] [] = (code, Halted (code ! 0), is)
exec _ _ _ _ _ = error "cannot exec"

indirect :: Code -> Mode -> Int -> Int
indirect code Imm parameter = parameter
indirect code Pos parameter = code ! parameter

decode :: Int -> (Instruction, [Mode])
decode raw = (i, L.map toEnum ([raw `div` (10 ^ (j + 1)) `mod` 10 | j <- [1 .. fst $ params i]]))
  where
    i = toInstruction $ raw `mod` 100

run :: Int -> [Int] -> Code -> (Inactive, Code, [Int])
run ptr inputs code = case flow of
  Continue -> run (ptr + ins + outs + 1) nextIs nextCode
  Jump x -> run x nextIs nextCode
  Suspend -> (Suspended (ptr + ins + outs + 1), nextCode, nextIs)
  Halted x -> (Resulted x, nextCode, nextIs)
  where
    (instr, modes) = decode (code ! ptr)
    (ins, outs) = (params instr)
    rawParams = [code ! (ptr + j) | j <- [1 .. ins]]
    fetchedParams = L.zipWith (indirect code) modes rawParams
    target = [code ! (ptr + ins + j) | j <- [1 .. outs]]
    (nextCode, flow, nextIs) = exec code inputs instr fetchedParams target

parse :: String -> Code
parse = fromList . fmap read . S.splitOn ","

prepare :: Code -> [Int] -> Vector (Inactive, Code)
prepare code phases = V.fromList [(Waiting i, code) | i <- phases]

comp machines i buffer =
  let (current, machine) = trace ((show i) L.++ " " L.++ (show buffer)) $ (machines ! i)
   in case current of
        Resulted _ -> if i == 4 then "last" else comp machines (i + 1) buffer
        Waiting x -> let (current', machine', buffer') = run 0 (x : buffer) machine in comp (update machines $ V.fromList [(i, (current', machine'))]) ((i + 1) `mod` 5) buffer'
        Suspended x -> let (current', machine', buffer') = run x buffer machine in comp (update machines $ V.fromList [(i, (current', machine'))]) ((i + 1) `mod` 5) buffer'

main = interact $ show . (\c -> L.map (\phases -> comp (prepare c phases) 0 [0]) (permutations [5 .. 9])) . parse
