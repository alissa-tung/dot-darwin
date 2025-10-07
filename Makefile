.PHONY: all fmt link update switch gc

all: update fmt switch link

HOSTNAME := $(shell scutil --get LocalHostName)

fmt:
	(fd -e nix -X nixfmt && fd -e nix -X alejandra -q)
	(prettier . -w)
	(taplo lint && taplo fmt)

link:
	(ln -sf ${PWD}/cfg/vsc.jsonc  ${HOME}'/Library/Application Support/Code/User/settings.json')
	(ln -sf ${PWD}/cfg/kitty.conf ${HOME}'/.config/kitty/kitty.conf')
	(ln -sf ${PWD}/cfg/helix.toml ${HOME}'/.config/helix/config.toml')
	(sudo ./scripts/link-gmp.sh)

update:
	(nix flake update)

switch:
	(sudo darwin-rebuild switch --flake .)

build:
	(nom build '.#darwinConfigurations.${HOSTNAME}.system')

gc:
	(sudo nix-collect-garbage -d && sudo nix store gc && sudo nix store optimise)
