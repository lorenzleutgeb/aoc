{
  description = "aoc";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
    lean.url = "github:leanprover/lean4";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, rust-overlay, lean, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];

        name = "AdventOfCode";

        leanPkgs = lean.packages.${system};
        leanPkg = leanPkgs.buildLeanPackage {
          inherit name;
          src = ./.;
        };

        pkgs = import nixpkgs { inherit system overlays; };

        rust = (pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" ];
        });

        up = pkgs.writeShellScriptBin "up" ''
          cp solve.hs ../2/solve.hs
          cd ../2
          pwd
        '';

        joinDepsDerivationns = getSubDrv:
          pkgs.lib.concatStringsSep ":" (map (d: "${getSubDrv d}") (leanPkg.allExternalDeps));
      in rec {
        devShell = pkgs.mkShell {
          inputsFrom = [ leanPkg.executable ];
          buildInputs = with pkgs; [
            cargo
            clippy
            ormolu
            rust
            #rustc
            #rustfmt

            stack
            up
            z3

            leanPkgs.lean-dev
            leanPkgs.lean-all
          ];
          RUST_SRC_PATH = "${rust}/lib/rustlib/src/rust/library/";
          LEAN_PATH = ".:" + joinDepsDerivationns (d: d.modRoot);
          LEAN_SRC_PATH = ".:" + joinDepsDerivationns (d: d.src);
          shellHook = ''
            stack --version
            z3 --version
            echo ${rust}
          '';
        };

        #packages = leanPkg // { inherit (leanPkgs) lean; };
        packages = leanPkg // {
          ${name} = leanPkg;
          inherit (leanPkgs) lean;
        };

        defaultPackage = leanPkg.modRoot;
      });
}
