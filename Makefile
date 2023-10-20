.PHONY: all fmt link update switch

all: fmt link update switch

fmt:
	(fd -e nix -x nixfmt && fd -e nix -x alejandra -q)
	(deno -q fmt)

link:
	(ln -sf ${PWD}/src/darwin-configuration.nix ${HOME}/.nixpkgs/darwin-configuration.nix)
	(ln -sf ${PWD}/cfg/vsc.jsonc                ${HOME}'/Library/Application Support/Code/User/settings.json')

update:
	(mkdir -p gen/ && ./scripts/vsc-ext.sh > gen/vsc.nix)
	(sudo nix-channel --update)
	(nix-channel --update)

switch:
	(darwin-rebuild switch)
	(sudo ./scripts/link-gmp.sh)
