{ lib, ... }: {
  imports = [
      ./configuration.nix
  ];
  nixpkgs.localSystem.system = "aarch64-linux";

  sdImage.imageBaseName = "raspberrypi-aarch64";
  # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low
  # on space.
  sdImage.compressImage = false;
  # bigger /boot size, otherwise deploying with nixops new kernels will become
  # impossible.
  sdImage.firmwareSize = lib.mkForce 512;
}