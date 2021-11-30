{
  description = "aoc";
  inputs.nixpkgs = { url = "nixpkgs/nixos-20.09"; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      up = pkgs.writeShellScriptBin "up" ''
        cp solve.hs ../2/solve.hs
        cd ../2
        pwd
      '';
    in rec {
      devShell."${system}" =
        with pkgs;
        mkShell {
          buildInputs = [
            clippy
            ormolu
            rustc
            rustfmt
            stack
            up
            z3
          ];
          shellHook = ''
            stack --version
            z3 --version
          '';
      };
  };
}
