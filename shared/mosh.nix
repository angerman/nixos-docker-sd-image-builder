{ ... }:
{
  nixpkgs.overlays = [
    (import ./overlays/mosh.nix)
  ];

  # mosh for better shells.
  programs.mosh.enable = true;

}