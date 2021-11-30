{- stack script
 --resolver ghc-8.10.2
 -}

import Data.List as L
import Data.List.Split as S
import Data.Vector as V
import Debug.Trace (trace)

type Code = Vector Int

data Flow = Halted | Jump Int | Suspend | Continue

data Inactive = Resulted | Suspended | Waiting Int

data Mode = Imm | Pos deriving (Show)

toMode 0 = Pos
toMode 1 = Imm
toMode _ = error "unknown mode"

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
params Jnz = (2, 0)
params Jz = (2, 0)
params Lt = (2, 1)
params Eq = (2, 1)
params Halt = (0, 0)

data Machine = Machine
  { code :: Code,
    ptr :: Int,
    i :: [Int],
    o :: [Int],
    result :: Maybe Int
  }

write :: Code -> [Int] -> [Int] -> Int -> Int -> (Code, Flow, [Int], [Int])
write code is os x c = (update code $ V.fromList [(c, x)], Continue, is, os)

exec :: Code -> [Int] -> [Int] -> Instruction -> [Int] -> [Int] -> (Code, Flow, [Int], [Int])
exec code is os Add [a, b] [c] = write code is os (a + b) c
exec code is os Mul [a, b] [c] = write code is os (a * b) c
exec code (i : is) os In [] [c] = (write code is os i c)
exec code is os Out [x] _ = (code, Suspend, is L.++ [x], os)
exec code is os Jnz [a, b] [] = (code, if a /= 0 then Jump b else Continue, is, os)
exec code is os Jz [a, b] [] = (code, if a == 0 then Jump b else Continue, is, os)
exec code is os Lt [a, b] [c] = write code is os (fromEnum $ a < b) c
exec code is os Eq [a, b] [c] = write code is os (fromEnum $ a == b) c
exec code is os Halt [] [] = (code, Halted, is, os)
exec _ _ _ _ _ _ = error "cannot exec"

run :: Machine -> Machine
run (Machine code ptr i o Nothing) = case flow of
  Jump x -> run (Machine nextCode x nextIs nextOs Nothing)
  --Suspend -> Machine nextCode (ptr + ins + outs + 1) nextIs nextOs Nothing
  Halted -> Machine nextCode 0 nextIs nextOs (Just (nextCode ! 0))
  _ -> run (Machine nextCode (ptr + ins + outs + 1) nextIs nextOs Nothing)
  where
    (instr, modes) = decode (code ! ptr)
    (ins, outs) = (params instr)
    rawParams = [code ! (ptr + j) | j <- [1 .. ins]]
    fetchedParams = L.zipWith (indirect code) modes rawParams
    target = [code ! (ptr + ins + j) | j <- [1 .. outs]]
    (nextCode, flow, nextIs, nextOs) = exec code i o instr fetchedParams target

indirect :: Code -> Mode -> Int -> Int
indirect code Imm parameter = parameter
indirect code Pos parameter = code ! parameter

decode :: Int -> (Instruction, [Mode])
decode raw = (i, L.map toMode ([raw `div` (10 ^ (j + 1)) `mod` 10 | j <- [1 .. fst $ params i]]))
  where
    i = toInstruction $ raw `mod` 100

parse :: String -> Code
parse = fromList . fmap read . S.splitOn ","

prepare :: Code -> [Int] -> Vector (Inactive, Code)
prepare code phases = V.fromList [(Waiting i, code) | i <- phases]

runPipe :: [Int] -> Machine -> [Int]
runPipe i (Machine code ptr _ o Nothing) = o'
  where
    (Machine _ _ _ o' _) = run (Machine code ptr i o Nothing)

--comp machines i buffer = let (current, machine) = trace ((show i) L.++ " " L.++ (show buffer)) $ (machines!i) in case current of
--  Resulted -> if i == 4 then "last" else comp machines (i + 1) buffer
--  Waiting x -> let (current', machine', buffer') = run 0 (x:buffer) machine in comp (update machines $ V.fromList [(i, (current', machine'))]) ((i + 1) `mod` 5) buffer'
--  Suspended -> let (current', machine', buffer') = run x buffer machine in comp (update machines $ V.fromList [(i, (current', machine'))]) ((i + 1) `mod` 5) buffer'

emptyMachine code = Machine code 0 [] [] Nothing

thrust code =
  L.maximum $ L.map f $ permutations [5 .. 9]
  where
    machine = emptyMachine code
    f [a, b, c, d, e] =
      let o1 = runPipe (a : 0 : o5) machine
          o2 = runPipe (b : o1) machine
          o3 = runPipe (c : o2) machine
          o4 = runPipe (d : o3) machine
          o5 = runPipe (e : o4) machine
       in L.last o5

main = interact $ show . thrust . parse

--
--not 8650074
