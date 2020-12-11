{
  network.description = "helios64 nodes";

  helios64 =
    { config, pkgs, ... }:
    { deployment.targetHost = "10.0.0.3";
      nixpkgs.localSystem.system = "aarch64-linux"; };
}
