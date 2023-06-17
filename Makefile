.PHONY: all fmt link build

all: fmt link build

fmt:
	(fd -e nix -x alejandra -q)

link:
	(ln -sf ${PWD}/src/darwin-configuration.nix ${HOME}/.nixpkgs/darwin-configuration.nix)
	(ln -sf ${PWD}/src/config.nix               ${HOME}/.nixpkgs/config.nix)

build:
	(mkdir -p gen/ && ./scripts/vsc-ext.sh > gen/vsc.nix)
	(darwin-rebuild build)
