{
  nixpkgs,
  nix-darwin,
  nix-vscode-extensions,
  mac-app-util,
}: rec {
  buildOutputs = let
    names = builtins.attrNames (builtins.readDir ./cfg);
  in
    builtins.map (x: buildDarwinOutput (import (./cfg + "/${x}"))) names;

  buildDarwinOutput = {
    hostName,
    hostPlatform,
  }: {
    formatter."${hostPlatform}" = nixpkgs.legacyPackages."${hostPlatform}".alejandra;

    darwinConfigurations."${hostName}" = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        ./darwin-configuration.nix
        {nix.registry.nixpkgs.flake = nixpkgs;}
      ];
      specialArgs = {
        inherit hostPlatform nix-vscode-extensions;
      };
    };
  };
}
