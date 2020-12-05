with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "nixops-shell";

  buildInputs = [
    nixops
  ];

  revision = "1aa5271117107032e13f07bf025e3c4d26db8915"; # nixos-20.03 on 2020-06-07


  shellHook = ''

    export NIX_PATH="nixpkgs=https://github.com/NixOs/nixpkgs-channels/archive/${revision}.tar.gz:."
    export NIXOPS_STATE="./secrets/state.nixops"

    function our_create () {
      if [ `nixops list | grep -c $1` -eq 0 ]
      then
       (set -x; nixops create --deployment $1 "<$1.nix>")
      fi
    }

  '';
}