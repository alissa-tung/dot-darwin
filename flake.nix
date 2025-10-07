{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
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
    mac-app-util,
  }: let
    lib = nixpkgs.lib;
    flake-lib = import ./src/lib.nix {
      inherit
        nixpkgs
        nix-darwin
        nix-vscode-extensions
        mac-app-util
        ;
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
