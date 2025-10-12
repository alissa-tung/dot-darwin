{
  pkgs,
  nix-vscode-extensions,
  hostPlatform,
  ...
}:
pkgs.vscode-with-extensions.override {
  vscodeExtensions = (
    with nix-vscode-extensions.extensions.${hostPlatform}.vscode-marketplace; [
      myriad-dreamin.tinymist
      jnoortheen.nix-ide
      ms-python.python
      ms-python.pylint
      ms-pyright.pyright
      charliermarsh.ruff
      james-yu.latex-workshop
      matthewpi.caddyfile-support
      rust-lang.rust-analyzer

      sainnhe.everforest
      leanprover.lean4
      redhat.vscode-yaml
      (ms-vscode-remote.remote-ssh.overrideAttrs (prev: {
        meta =
          prev.meta
          // {
            license = [];
          };
      }))
      tamasfe.even-better-toml
      bradlc.vscode-tailwindcss
      ms-vscode.vscode-typescript-next
      bradlc.vscode-tailwindcss
      yoavbls.pretty-ts-errors
      million.million-lint
      svelte.svelte-vscode
      llvm-vs-code-extensions.vscode-clangd
      prisma.prisma
      bufbuild.vscode-buf
      berberman.vscode-cabal-fmt
      justusadam.language-haskell
      dramforever.vscode-ghc-simple
      haskell.haskell
      catppuccin.catppuccin-vsc-pack
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      # bamboo.idris2-lsp
      golang.go
      detachhead.basedpyright
      scalameta.metals
    ]
  );
}
