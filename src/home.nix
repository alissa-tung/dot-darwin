{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [<home-manager/nix-darwin>];

  users.users.alissatung = {
    name = "alissatung";
    home = "/Users/alissatung";
  };

  home-manager.useUserPackages = false;
  home-manager.users.alissatung = {...}: {
    home.stateVersion = "23.05";

    programs.vscode = {
      enable = true;
      userSettings = builtins.fromJSON (builtins.readFile ../cfg/vsc.jsonc);
    };
  };
}
