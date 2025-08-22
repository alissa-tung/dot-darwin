{pkgs, ...}:
pkgs.vscode-with-extensions.override {
  vscodeExtensions = with pkgs.vscode-extensions;
    [
      myriad-dreamin.tinymist
      jnoortheen.nix-ide
      ms-python.python
      ms-python.pylint
      ms-pyright.pyright
      charliermarsh.ruff
      james-yu.latex-workshop
      matthewpi.caddyfile-support
      rust-lang.rust-analyzer
    ]
    ++ map (
      extension:
        pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            inherit
              (extension)
              name
              publisher
              version
              sha256
              ;
          };
        }
    )
    (import ../gen/vsc.nix).extensions;
}
