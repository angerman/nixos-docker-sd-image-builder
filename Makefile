helios64-image:
	nix-build -A config.system.build.sdImage \
		--argstr system aarch64-linux \
		-I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz \
		-I nixos-config=./helios64-node/sd-image.nix \
		'<nixpkgs/nixos/default.nix>' \
		--option builders-use-substitutes true \
		--cores 0