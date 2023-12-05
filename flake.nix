{
  description = "aoc";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lean = {
      url = "github:leanprover/lean4/v4.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mathlib = {
      url = "github:leanprover-community/mathlib4/v4.2.0";
      flake = false;
    };
    std = {
      url = "github:leanprover/std4/v4.2.0";
      flake = false;
    };
    cli = {
      url = "github:leanprover/lean4-cli/v2.2.0-lv4.0.0";
      flake = false;
    };
    aesop = {
      url = "github:leanprover-community/aesop/v4.2.0";
      flake = false;
    };
    quote = {
      url = "github:leanprover-community/quote4";
      flake = false;
    };
    ProofWidgets = {
      url = "github:leanprover-community/ProofWidgets4/v0.0.23";
      flake = false;
    };
  };
  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux";
    overlays = [(import inputs.rust-overlay)];
    name = "AdventOfCode";
    leanPkgs = inputs.lean.packages.${system};

    # addFakeFile can plug into buildLeanPackage’s overrideBuildModAttrs
    # it takes a lean module name and a filename, and makes that file available
    # (as an empty file) in the build tree, e.g. for include_str.
    addFakeFiles = m: self: super:
      if m ? ${super.name}
      then let
        paths = m.${super.name};
      in {
        src =
          pkgs.runCommandCC "${super.name}-patched" {
            inherit (super) leanPath src relpath;
          } (''
              dir=$(dirname $relpath)
              mkdir -p $out/$dir
              if [ -d $src ]; then cp -r $src/. $out/$dir/; else cp $src $out/$leanPath; fi
            ''
            + pkgs.lib.concatMapStringsSep "\n" (p: ''
              install -D -m 644 ${pkgs.emptyFile} $out/${p}
            '')
            paths);
      }
      else {};

    std = leanPkgs.buildLeanPackage {
      name = "Std";
      src = inputs.std;
      roots = [
        {
          mod = "Std";
          glob = "one";
        }
      ];
    };

    quote = leanPkgs.buildLeanPackage {
      name = "Qq";
      src = inputs.quote;
      roots = [
        {
          mod = "Qq";
          glob = "one";
        }
      ];
    };

    aesop = leanPkgs.buildLeanPackage {
      name = "Aesop";
      src = inputs.aesop;
      roots = ["Aesop"];
      deps = [std];
    };

    cli = leanPkgs.buildLeanPackage {
      name = "Cli";
      src = inputs.cli;
      roots = ["Cli"];
      deps = [std];
    };

    ProofWidgets = leanPkgs.buildLeanPackage {
      name = "ProofWidgets";
      src = inputs.ProofWidgets;
      roots = ["ProofWidgets"];
      deps = [std];
      overrideBuildModAttrs = addFakeFiles {
        "ProofWidgets.Compat" = [".lake/build/js/compat.js"];
        "ProofWidgets.Component.Basic" = [".lake/build/js/interactiveExpr.js"];
        "ProofWidgets.Component.GoalTypePanel" = [".lake/build/js/goalTypePanel.js"];
        "ProofWidgets.Component.Recharts" = [".lake/build/js/recharts.js"];
        "ProofWidgets.Component.PenroseDiagram" = [".lake/build/js/penroseDisplay.js"];
        "ProofWidgets.Component.Panel.SelectionPanel" = [".lake/build/js/presentSelection.js"];
        "ProofWidgets.Component.Panel.GoalTypePanel" = [".lake/build/js/goalTypePanel.js"];
        "ProofWidgets.Component.MakeEditLink" = [".lake/build/js/makeEditLink.js"];
        "ProofWidgets.Component.OfRpcMethod" = [".lake/build/js/ofRpcMethod.js"];
        "ProofWidgets.Component.HtmlDisplay" = [".lake/build/js/htmlDisplay.js" ".lake/build/js/htmlDisplayPanel.js"];
        "ProofWidgets.Presentation.Expr" = [".lake/build/js/exprPresentation.js"];
      };
    };

    mathlib = leanPkgs.buildLeanPackage {
      name = "Mathlib";
      src = inputs.mathlib;
      roots = [
        {
          mod = "Mathlib";
          glob = "one";
        }
      ];
      leanFlags = [
        "-Dpp.unicode.fun=true"
        "-DautoImplicit=false"
        "-DrelaxedAutoImplicit=false"
      ];
      deps = [std quote aesop ProofWidgets];
      overrideBuildModAttrs = addFakeFiles {
        "Mathlib.Tactic.Widget.CommDiag" = [
          "widget/src/penrose/commutative.dsl"
          "widget/src/penrose/commutative.sty"
          "widget/src/penrose/triangle.sub"
          "widget/src/penrose/square.sub"
        ];
      };
    };

    leanPkg = leanPkgs.buildLeanPackage {
      inherit name;
      src = ./.;
      roots = ["AdventOfCode"];
      deps = [mathlib cli];
    };

    pkgs = import inputs.nixpkgs {inherit system overlays;};

    rust = pkgs.rust-bin.stable.latest.default.override {
      extensions = ["rust-src"];
    };

    up = pkgs.writeShellScriptBin "up" ''
      cp solve.hs ../2/solve.hs
      cd ../2
      pwd
    '';

    joinDepsDerivationns = getSubDrv:
      pkgs.lib.concatStringsSep ":" (map (d: "${getSubDrv d}") (leanPkg.allExternalDeps));
  in rec {
    devShell.${system} = pkgs.mkShell {
      inputsFrom = [leanPkg.executable];
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

        lean4
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
    packages.${system} = {
      ${name} = leanPkg.executable;
      #inherit (leanPkgs) lean;
      #inherit (leanPkg) print-paths;
    };

    #defaultPackage.${system} = leanPkg.modRoot;
  };
}
