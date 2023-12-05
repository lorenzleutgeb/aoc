import Lake
open Lake DSL

require Cli from git "https://github.com/leanprover/lean4-cli" @ "v2.2.0-lv4.0.0"

package «AdventOfCode» where
  -- add package configuration options here

lean_lib «AdventOfCode» where
  -- add library configuration options here

@[default_target]
lean_exe «aoc» where
  root := `AdventOfCode.Main
  -- Enables the use of the Lean interpreter by the executable (e.g.,
  -- `runFrontend`) at the expense of increased binary size on Linux.
  -- Remove this line if you do not need such functionality.
  supportInterpreter := true
