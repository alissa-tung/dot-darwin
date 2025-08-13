.PHONY: all fmt link update switch gc

all: update fmt switch link

HOSTNAME := $(shell scutil --get LocalHostName)

fmt:
	(fd -e nix -X nixfmt && fd -e nix -X alejandra -q)
	(prettier . -w)

link:
	(ln -sf ${PWD}/cfg/vsc.jsonc ${HOME}'/Library/Application Support/Code/User/settings.json')
	(sudo ./scripts/link-gmp.sh)

update:
	(nix flake update)
	(mkdir -p gen/ && ./scripts/vsc-ext.sh > gen/vsc.nix)
	(rm -rf ./tmp-for-vsc)

switch:
	(rm -rf '/Applications/Nix Apps')
	(sudo darwin-rebuild switch --flake .)

build:
	(nom build '.#darwinConfigurations.${HOSTNAME}.system')

gc:
	(sudo nix-collect-garbage -d && sudo nix store gc && sudo nix store optimise)
