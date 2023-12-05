/--
def List.take : List α → Nat → List α
  | _, 0      => []
  | [], _+1    => []
  | a::as, n+1 => a :: take n as
-/

def List.tails : List α → List (List α)
 | []    => []::[]
 | x::xs => (x::xs)::(xs.tails)

#eval [1, 2, 3].tails

def List.sum [HAdd α α α] [Inhabited α] : List α → α := List.foldl HAdd.hAdd Inhabited.default

#eval [1, 2, 3].sum

namespace AdventOfCode.Y2021.D1

def p1 [LT α] [DecidableRel (@LT.lt α _)] (ns : List α) : Nat := List.length $ List.filter (fun x => x == true) $ List.zipWith (fun a b => LT.lt a b) ns (ns.tail!)

def p2 [LT α] [DecidableRel (@LT.lt α _)] [HAdd α α α] [Inhabited α] (ns : List α) : Nat := p1 $ List.map (fun x => List.sum (x.take 3)) $ ns.tails

partial def lines : IO (List String) := do
  let line := (←  (← IO.getStdin).getLine)
  match line with
  | "" => return []
  | x  =>
      let rest ← lines
      return (x.trim)::rest

partial def main : IO Unit := do
  let ns := (← lines).map String.toInt!
  IO.println $ p1 ns
  IO.println $ p2 ns
