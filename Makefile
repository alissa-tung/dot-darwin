.PHONY: all fmt link update switch

all: fmt link update switch

fmt:
	(fd -e nix -x alejandra -q)
	(deno -q fmt)

link:
	(ln -sf ${PWD}/src/darwin-configuration.nix ${HOME}/.nixpkgs/darwin-configuration.nix)
	(ln -sf ${PWD}/src/config.nix               ${HOME}/.nixpkgs/config.nix)

update:
	(mkdir -p gen/ && ./scripts/vsc-ext.sh > gen/vsc.nix)
	(nix-channel --update)

switch:
	(darwin-rebuild switch)
	(sudo ./scripts/link-gmp.sh)
