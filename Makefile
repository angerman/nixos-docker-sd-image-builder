helios64-image:
	nix-build -A config.system.build.sdImage \
		--argstr system aarch64-linux \
		-I nixpkgs=https://github.com/NixOS/nixpkgs/archive/65c9cc79f1d179713c227bf447fb0dac384cdcda.tar.gz \
		-I nixos-config=./helios64-node/sd-image.nix \
		'<nixpkgs/nixos/default.nix>' \
		--option builders-use-substitutes true \
		--cores 0