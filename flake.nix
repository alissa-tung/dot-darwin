{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    forester = {
      url = "sourcehut:~jonsterling/ocaml-forester";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-darwin,
    forester,
    ...
  }: let
    lib = nixpkgs.lib;
    flake-lib = import ./src/lib.nix {
      inherit nixpkgs nix-darwin;
      extraArgs = {
        inherit forester;
      };
    };
  in
    (flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
      }
    ))
    // builtins.foldl' (acc: x: lib.recursiveUpdate acc x) {} flake-lib.buildOutputs;
}
