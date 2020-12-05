{
  network.description = "raspberry nodes";

  pihole =
    { config, pkgs, ... }:
    { deployment.targetHost = "10.0.0.2";
      nixpkgs.localSystem.system = "aarch64-linux"; };

  rasp4-1 =
    { config, pkgs, ... }:
    { deployment.targetHost = "10.0.0.92";
      nixpkgs.localSystem.system = "aarch64-linux"; };

  rasp4-2 =
    { config, pkgs, ... }:
    { deployment.targetHost = "10.0.0.93";
      nixpkgs.localSystem.system = "aarch64-linux"; };

}
