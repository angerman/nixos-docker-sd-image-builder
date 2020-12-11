with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "nixops-shell";

  buildInputs = [
    nixops
  ];

  revision = "65c9cc79f1d179713c227bf447fb0dac384cdcda"; # nixos-20.09 on 2020-12-11


  shellHook = ''

    export NIX_PATH="nixpkgs=https://github.com/NixOs/nixpkgs/archive/${revision}.tar.gz:."
    export NIXOPS_STATE="./secrets/state.nixops"

    function our_create () {
      if [ `nixops list | grep -c $1` -eq 0 ]
      then
       (set -x; nixops create --deployment $1 "<$1.nix>")
      fi
    }

  '';
}