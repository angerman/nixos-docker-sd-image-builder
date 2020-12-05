#! /usr/bin/env nix-shell
#! nix-shell -p nixops nix jq bash -i bash

top="$(cd `dirname $0`; pwd)"

# export NIX_PATH="$top"
export NIX_PATH="nixpkgs=http://nixos.org/channels/nixos-20.09/nixexprs.tar.xz"
export NIXOPS_STATE="$top/secrets/state.nixops"
export NIXOPS_DEPLOYMENT=rpi4-node

if [ $1 == "deploy" ]; then
  keys="$(nix show-config --json  | jq -r '.["trusted-public-keys"].value|join(" ")')"
  cache=("--option" "trusted-public-keys" "'$keys'")
else
  cache=()
fi

exec nixops "$@" "${cache[@]}"
