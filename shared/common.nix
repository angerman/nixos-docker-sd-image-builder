{ ... }:
{
  imports = [
    ./ntp.nix
    ./users.nix
    # ./mosh.nix
    # ./prometheus.nix
  ];

  # generic overlays, that are not already imported by the imported by the
  # imports above.
  nixpkgs.overlays = [
    (import ./overlays/ap6256.nix)
  ];
}