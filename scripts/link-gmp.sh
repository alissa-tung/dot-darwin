#!/usr/bin/env bash
set -e

system_path_drv=$(ls -ll /run/current-system/sw | rev | cut -d ' ' -f 1 | rev)
gmp_out=$(nix derivation show "$system_path_drv" | \
  jq ".[].env.pkgs"                    | \
  grep -o '/nix/store/[^"]*-gmp-[^"]*' | \
  grep -v "info"                       | \
  sed 's/\\//g'                        | \
  xargs)

mkdir -p /usr/local/opt/gmp/lib/
ln -sf "$gmp_out/lib/libgmp.10.dylib" /usr/local/opt/gmp/lib/libgmp.10.dylib
