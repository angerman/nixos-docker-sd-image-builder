{ pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./gpt-sd-image.nix
  ];
  nixpkgs.localSystem.system = "aarch64-linux";

  sdImage.imageBaseName = "helios64";
  # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low
  # on space.
  sdImage.compressImage = false;

  # Include lots of firmware.
  hardware.enableRedistributableFirmware = true;

}