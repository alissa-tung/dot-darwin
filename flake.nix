{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-darwin,
    nix-vscode-extensions,
    ...
  }: let
    lib = nixpkgs.lib;
    flake-lib = import ./src/lib.nix {
      inherit nixpkgs nix-darwin nix-vscode-extensions;
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
