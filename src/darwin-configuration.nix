{
  config,
  lib,
  ...
}: let
  pkgs = import <nixpkgs> {config.allowUnfree = true;};
in ({
    services.nix-daemon.enable = true;
    nix = {
      package = pkgs.nix;

      settings = {
        experimental-features = ["nix-command" "flakes" "repl-flake"];

        substituters = [
          "https://mirrors.bfsu.edu.cn/nix-channels/store/"
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://cache.nixos.org"
        ];
      };
    };

    environment.variables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
    };

    environment.systemPackages = with pkgs;
      [
        coreutils
        openssh
        neovim
        git
        gnumake
        cmake
        gcc
        clang-tools
        fd
        ripgrep
        jq
        curl
        unar
        tree
        rlwrap
        bottom
      ]
      ++ [alejandra nixfmt nil deno yamlfmt taplo ormolu hlint shellcheck]
      ++ [rustup elan nodejs]
      ++ [caddy]
      ++ [gmp libiconv]
      ++ lib.lists.singleton (import ../pkgs/vscode.nix {inherit pkgs;})
      ++ lib.lists.singleton (python311.withPackages
        (pythonPackages: with pythonPackages; [pyyaml loguru]))
      ++ lib.lists.singleton (agda.withPackages (agdaPackages:
        with agdaPackages; [
          standard-library
          cubical
          agda-categories
        ]));

    programs.zsh = {
      enable = true;
      promptInit = lib.mkForce "";
      interactiveShellInit =
        ''
          source "${pkgs.grml-zsh-config}/etc/zsh/zshrc"
          source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
          source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        ''
        + builtins.readFile ../cfg/zshrc;
    };
  }
  // {
    system.stateVersion = 4;
  })
