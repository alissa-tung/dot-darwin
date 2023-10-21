.PHONY: all fmt link update switch gc

all: fmt link update switch

fmt:
	(fd -e nix -x nixfmt && fd -e nix -x alejandra -q)
	(deno -q fmt)

link:
	(ln -sf ${PWD}/src/darwin-configuration.nix ${HOME}/.nixpkgs/darwin-configuration.nix)
	(ln -sf ${PWD}/cfg/vsc.jsonc                ${HOME}'/Library/Application Support/Code/User/settings.json')

update:
	(nix flake update)
	(mkdir -p gen/ && ./scripts/vsc-ext.sh > gen/vsc.nix)
	(sudo nix-channel --update)
	(nix-channel --update)

switch:
	(nix run nix-darwin -- switch --flake .)
	(sudo ./scripts/link-gmp.sh)

gc:
	(sudo nix-collect-garbage -d && sudo nix-store --gc && sudo nix-store --optimise)
