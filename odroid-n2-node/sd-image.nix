{ pkgs, lib, ... }:
{
  imports = [
    ./configuration.nix
  ];
  nixpkgs.localSystem.system = "aarch64-linux";

  sdImage.imageBaseName = "odroid-n2";
  # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low
  # on space.
  sdImage.compressImage = false;
  sdImage.populateFirmwareCommands = ''
    dd conv=notrunc if="${pkgs.fipOdroidN2}/u-boot.bin" of=$img conv=fsync,notrunc bs=512 seek=1
  '';

  # bigger /boot size, otherwise deploying with nixops new kernels will become
  # impossible.
  sdImage.firmwareSize = lib.mkForce 512;

  # Include lots of firmware.
  hardware.enableRedistributableFirmware = true;
}