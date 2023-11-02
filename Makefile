.PHONY: all fmt link update switch gc

all: update fmt switch link

fmt:
	(fd -e nix -x nixfmt && fd -e nix -x alejandra -q)
	(deno -q fmt)

link:
	(ln -sf ${PWD}/cfg/vsc.jsonc ${HOME}'/Library/Application Support/Code/User/settings.json')
	(sudo ./scripts/link-gmp.sh)

update:
	(nix flake update)
	(mkdir -p gen/ && ./scripts/vsc-ext.sh > gen/vsc.nix)

switch:
	(nix run nix-darwin -- switch --flake .)

gc:
	(sudo nix-collect-garbage -d && sudo nix-store --gc && sudo nix-store --optimise)
