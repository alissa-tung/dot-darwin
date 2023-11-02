{
  pkgs,
  config,
  lib,
  hostPlatform,
  ...
}: ({
    services.nix-daemon.enable = true;

    launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables.https_proxy = "http://127.0.0.1:9520";
    launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables.http_proxy = "http://127.0.0.1:9520";

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

    nixpkgs = {
      inherit hostPlatform;
      config.allowUnfree = true;
    };

    environment.variables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
    };

    environment.systemPackages = with pkgs;
      [
        coreutils
        gnused
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
      ++ [rustup cargo-edit elan nodejs_21 protobuf buf protoc-gen-dart]
      ++ [caddy sqlite]
      ++ [gmp libiconv]
      ++ lib.lists.singleton (import ../pkgs/vscode.nix {inherit pkgs;})
      ++ lib.lists.singleton (python311.withPackages (pythonPackages:
        with pythonPackages; [
          pyyaml
          sphinx
          sphinx-rtd-theme
          regex
          loguru
        ]))
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
