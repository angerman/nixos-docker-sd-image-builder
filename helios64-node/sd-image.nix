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

  # This does not appear to work, otherwise we could use the stock sd-image.nix
  # sdImage.populateFirmwareCommands = ''
  #     dd conv=notrunc if=${pkgs.ubootHelios64}/u-boot.itb    of=$img seek=64    count=8000
  #     dd conv=notrunc if=${pkgs.ubootHelios64}/idbloader.img of=$img seek=16384 count=8192
  # '';

  # Include lots of firmware.
  hardware.enableRedistributableFirmware = true;
}