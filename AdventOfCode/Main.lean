import AdventOfCode
import Cli

def runCmd (p : Cli.Parsed) : IO UInt32 := do
  let year : Nat := p.positionalArg! "year" |>.as! Nat
  let day  : Nat := p.positionalArg! "day"  |>.as! Nat

  if year == 2021 && day == 1 then
    AdventOfCode.Y2022.D1.main
  if year == 2022 && day == 1 then
    AdventOfCode.Y2022.D1.main

  return 0

def cmd : Cli.Cmd := `[Cli|
  cmd VIA runCmd; ["0.0.1"]
  "Advent of Code"

  ARGS:
    year : Nat; "The year."
    day  : Nat; "The day."
]

def main (args : List String) : IO UInt32 := do
  cmd.validate args
