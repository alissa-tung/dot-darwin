{pkgs, ...}:
pkgs.vscode-with-extensions.override {
  vscodeExtensions = map (extension:
    pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {inherit (extension) name publisher version sha256;};
    })
  (import ../gen/vsc.nix).extensions;
}
