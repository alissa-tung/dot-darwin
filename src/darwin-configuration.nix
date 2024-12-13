{
  pkgs,
  config,
  lib,
  hostPlatform,
  forester,
  ...
}: (
  {
    services.nix-daemon.enable = true;
    nix = {
      package = pkgs.nix;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://mirrors.bfsu.edu.cn/nix-channels/store/"
          "https://mirror.sjtu.edu.cn/nix-channels/store/"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/"
          "https://mirrors.ustc.edu.cn/nix-channels/store/"
        ];

        trusted-users = [
          "root"
          "alissa"
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
        openssl
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
        du-dust
        nix-output-monitor
        nix-inspect
        kitty
        helix
      ]
      ++ [
        alejandra
        nixfmt-rfc-style
        nil
        taplo
        shellcheck
      ]
      ++ [
        rustup
        cargo-edit
        elan
        protobuf
        buf
        # protoc-gen-dart
        go
        goreleaser
        # millet
        black
      ]
      ++ [
        caddy
        sqlite
      ]
      ++ [
        ccache
        clang-tools

        gmp
        libuv
        libiconv
      ]
      ++ [emacs]
      ++ lib.lists.singleton (import ../pkgs/vscode.nix {inherit pkgs;})
      ++ lib.lists.singleton (
        python311.withPackages (
          pythonPackages:
            with pythonPackages; [
              chardet
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
              pyserial
            ]
        )
      )
      # ++ lib.lists.singleton (
      #   agda.withPackages (
      #     agdaPackages:
      #       with agdaPackages; [
      #         standard-library
      #         cubical
      #         agda-categories
      #       ]
      #   )
      # )
      # ++ [
      #   ocaml
      #   ocamlformat
      #   dune_3
      # ]
      # ++ (with ocamlPackages; [
      #   findlib
      #   ocaml-lsp
      # ])
      ++ (with pkgs.nodePackages_latest; [
        nodejs
        prettier
        pnpm
        eslint
      ])
      # ++ lib.lists.singleton forester.packages.${hostPlatform}.default
      ++ (with haskellPackages; [cabal-fmt])
      ++ [
        llvm_18
        ormolu
        hlint
      ]
      ++ [
        # idris2
        # idris2Packages.idris2Lsp
      ];

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
  }
)
