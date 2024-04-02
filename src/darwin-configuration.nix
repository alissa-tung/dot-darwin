{
  pkgs,
  config,
  lib,
  hostPlatform,
  forester,
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
          "https://mirror.sjtu.edu.cn/nix-channels/store/"
        ];

        trusted-users = ["root" "alissa"];

        # builders = "ssh-ng://builder@linux-builder x86_64-linux /etc/nix/builder_ed25519 4 - - - AAAAC3NzaC1lZDI1NTE5AAAAII4qvxathhmm1KQn6/Zy3Zd2K3CaqvcfpZr6IBSm6faw";
        # builders-use-substitutes = true;
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
        ghc
        ripgrep
        jq
        curl
        unar
        tree
        rlwrap
        bottom
        du-dust
        nix-output-monitor
        cloudflared
        (octave.withPackages (octavePackages: with octavePackages; [symbolic]))
      ]
      ++ [alejandra nixfmt nil taplo ormolu hlint shellcheck]
      ++ [
        rustup
        cargo-edit
        elan
        protobuf
        buf
        protoc-gen-dart
        go
        goreleaser
        millet
        black
      ]
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
          requests
          beautifulsoup4
          tkinter
          pandas
          duckdb
          numpy
          matplotlib
          ipython
          sympy
        ]))
      ++ lib.lists.singleton (agda.withPackages (agdaPackages:
        with agdaPackages; [
          standard-library
          cubical
          agda-categories
        ]))
      ++ [ocaml ocamlformat dune_3]
      ++ (with ocamlPackages; [findlib ocaml-lsp])
      ++ (with pkgs.nodePackages_latest; [nodejs prettier pnpm eslint])
      ++ lib.lists.singleton forester.packages.${hostPlatform}.default;

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
