{
  pkgs,
  config,
  lib,
  hostPlatform,
  nix-vscode-extensions,
  ...
}: (
  {
    system.primaryUser = "alissa";
    # services.yabai.enable = true;

    # users.users.alissa = {
    #   name = "alissa";
    # };

    fonts.packages = [
      pkgs.ibm-plex
      pkgs.texlivePackages.fandol
      pkgs.sarasa-gothic
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-cjk-sans
    ];

    nix = {
      package = pkgs.nix;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://mirrors.bfsu.edu.cn/nix-channels/store/"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/"
          "https://mirrors.ustc.edu.cn/nix-channels/store/"
          # "https://mirror.sjtu.edu.cn/nix-channels/store/"
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
      EDITOR = "hx";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    environment.systemPackages = with pkgs;
      [
        kitty
        # yabai
        # skhd

        zsh
        zoxide
        coreutils
        findutils
        gnused
        openssh
        openssl
        git
        git-lfs
        gh
        gnumake
        cmake
        gcc
        clang
        clang-tools
        fd
        ripgrep
        jq
        curl
        unar
        tree
        rlwrap
        bottom
        dust
        delta
        nix-output-monitor
        nix-inspect
        helix
        typescript-language-server
        uv
        ruff
        pandoc
        texliveFull
        texlab
        sioyek
        fastfetch
      ]
      ++ [
        alejandra
        nixfmt-rfc-style
        nil
        nixd
        taplo
        shellcheck
      ]
      ++ [
        rustup
        cargo-edit
        elan
        protobuf
        buf
        go
        goreleaser
        black
        tailwindcss-language-server
      ]
      ++ [
        caddy
        sqlite
      ]
      ++ [
        ccache

        gmp
        libuv
        libiconv
      ]
      ++ lib.lists.singleton (
        import ../pkgs/vscode.nix {inherit pkgs nix-vscode-extensions hostPlatform;}
      )
      ++ lib.lists.singleton (
        python311.withPackages (
          pythonPackages:
            with pythonPackages; [
              # uv
              # chardet
              # pyyaml
              # sphinx
              # sphinx-rtd-theme
              # regex
              # loguru
              # requests
              # beautifulsoup4
              # tkinter
              # pandas
              # duckdb
              # numpy
              # matplotlib
              # ipython
              # sympy
              # pyserial
            ]
        )
      )
      # ++ [
      #   # haskellPackages.agda-language-server
      #   (agda.withPackages (
      #     agdaPackages:
      #       with agdaPackages; [
      #         standard-library
      #         cubical
      #         agda-categories
      #       ]
      #   ))
      # ]
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
      ++ (with haskellPackages; [cabal-fmt])
      ++ [
        llvm
        lldb
        ormolu
        hlint
      ]
      ++ [
        # idris2
        # idris2Packages.idris2Lsp
      ]
      ++ [
        tinymist
        typst
      ];

    programs.zsh = {
      enable = true;
      promptInit = lib.mkForce "";
      interactiveShellInit =
        ''
          source "${pkgs.grml-zsh-config}/etc/zsh/zshrc"
          source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
          source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
          eval "$(zoxide init zsh)"
          alias zz=/usr/local/bin/zed
        ''
        + builtins.readFile ../cfg/zshrc;
    };
  }
  // {
    system.stateVersion = 6;
  }
)
