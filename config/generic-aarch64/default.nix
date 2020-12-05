{ config, lib, pkgs, ... }:

let
  extlinux-conf-builder =
    import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
      pkgs = pkgs.buildPackages;
    };
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/profiles/installation-device.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
  ];

  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 3;
  # must disable uboot, to get the geekwork x820 v3 usb disk working.
  # hdmi still doesn't come up, but ssh will.
  boot.loader.raspberryPi.uboot.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_rpi3;

  boot.consoleLogLevel = lib.mkDefault 7;

  boot.kernelParams = ["cma=32M" "console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];

  sdImage = {
    # This might need to be increased when deploying multiple configurations.
    firmwareSize = 128;
    # TODO: check if needed.
    populateFirmwareCommands =
      "${config.system.build.installBootLoader} ${config.system.build.toplevel} -d ./firmware";
    # /var/empty is needed for some services, such as sshd
    # XXX: This might not be needed anymore, adding to be extra sure.
    populateRootCommands = "mkdir -p ./files/var/empty";
  };

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;

  fileSystems = {
      # There is no U-Boot on the Pi 4, thus the firmware partition needs to be mounted as /boot.
      "/boot" = {
          device = "/dev/disk/by-label/FIRMWARE";
          fsType = "vfat";
      };
      "/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
      };
  };
}
