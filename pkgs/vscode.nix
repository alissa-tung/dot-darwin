{pkgs, ...}:
pkgs.vscode-with-extensions.override {
  vscodeExtensions = with pkgs.vscode-extensions;
    [
      # azdavis.millet
      myriad-dreamin.tinymist
      jnoortheen.nix-ide
      ms-python.python
      ms-python.pylint
      ms-pyright.pyright
      charliermarsh.ruff
      james-yu.latex-workshop
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
