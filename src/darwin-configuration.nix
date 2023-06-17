{
  config,
  lib,
  ...
}: let
  pkgs = import <nixpkgs> {config.allowUnfree = true;};
in ({
    environment.systemPackages = with pkgs;
      [
        neovim
        git
        gcc
        gnumake
        starship
        alejandra
        fd
        deno
      ]
      ++ [
        (import ../pkgs/vscode.nix {inherit pkgs;})
      ];

    programs.zsh = {
      enable = true;
      promptInit = lib.mkForce "";
      interactiveShellInit =
        ''
          source "${pkgs.grml-zsh-config}/etc/zsh/zshrc"
        ''
        + builtins.readFile ../cfg/zshrc;
    };

    services.nix-daemon.enable = true;
    nix.package = pkgs.nix;
  }
  // {
    system.stateVersion = 4;
  }
  // (import ./home.nix {inherit config lib pkgs;}))
