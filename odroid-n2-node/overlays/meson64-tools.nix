let sources = import ../../nix/sources.nix; in
final: prev: {
    inherit (import sources.meson64-tools { nixpkgs = final.buildPackages; }) meson64-tools;
}