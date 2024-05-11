{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "smlnj";
  version = "110.99.4";

  nativeBuildInputs = with pkgs; [
    xar
    cpio
  ];
  buildInputs = with pkgs; [
    gnused
    gnugrep
  ];

  srcs = [
    (pkgs.fetchFromGitHub {
      owner = "smlnj";
      repo = "legacy";
      rev = "41fa20580cbcdf74e2d064d052f70f46b5f5f08c";
      sha256 = "Ng6dnkm65KVyTZU9ZF7ggRZ/5zHPQeOvFfAcGPGWZ6s=";
    })
    (builtins.fetchurl {
      url = "http://smlnj.cs.uchicago.edu/dist/working/110.99.4/smlnj-amd64-110.99.4.pkg";
      sha256 = "18qr40wrb7a6caxbw6mcxbcq3g7vv472j9q5ndq3m94bgc0miy1b";
    })
  ];

  unpackPhase = "true";

  buildPhase = ''
    read -ra srcs <<< "$srcs"
    REPO="''${srcs[0]}"
    REL="''${srcs[1]}"

    cp -r $REPO smlnj-legacy

    mkdir smlnj-amd64-110.99.4 && cd smlnj-amd64-110.99.4
    xar -xf $REL
    cd smlnj.pkg
    zcat Payload | cpio -i
    export PATH=$PATH:$PWD/bin
    cd ../../smlnj-legacy

    config/install.sh
    cd base/system
    ./cmb-make
    ./makeml
    ./installml -clean
    cd ../..
    ls bin
  '';
  installPhase = ''
    mkdir -p $out
  '';
}
