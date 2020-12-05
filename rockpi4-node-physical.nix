{
  network.description = "rock nodes";

  rock4-1 =
    { config, pkgs, ... }:
    { deployment.targetHost = "10.0.0.99";
      nixpkgs.localSystem.system = "aarch64-linux"; };
}
