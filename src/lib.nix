{
  nixpkgs,
  nix-darwin,
}: rec {
  buildOutputs = let
    names = builtins.attrNames (builtins.readDir ./cfg);
  in
    builtins.map (x: buildDarwinOutput (import (./cfg + "/${x}"))) names;

  buildDarwinOutput = {
    hostName,
    hostPlatform,
  }: {
    formatter."${hostPlatform}" =
      nixpkgs.legacyPackages."${hostPlatform}".alejandra;

    darwinConfigurations."${hostName}" = nix-darwin.lib.darwinSystem {
      modules = [./darwin-configuration.nix];
      specialArgs = {inherit hostPlatform;};
    };
  };
}
