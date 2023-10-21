{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
  }: let
    lib = nixpkgs.lib;
    flake-lib = import ./src/lib.nix {inherit nixpkgs nix-darwin;};
  in
    {}
    // builtins.foldl' (acc: x: lib.recursiveUpdate acc x) {}
    flake-lib.buildOutputs;
}
