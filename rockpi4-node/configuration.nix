{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    ../shared
  ];

  nixpkgs.overlays = [
    (import ./overlays/u-boot.nix)
  ];

  hardware.firmware = [ pkgs.ap6256 ];

  # hardware.bluetooth.enable = false;
  # hardware.bluetooth.powerOnBoot = false;

  # enable nvme (in case of nvme drives)

  nixpkgs.config.packageOverrides = pkgs:
    { linux_rockpi4 = pkgs.linux_5_6.override {
        kernelPatches = [
          { name = "dts:rockchip-add-pcie-node"; patch = ./manjaro-linux-aarch64/0001-arm64-dts-rockchip-add-pcie-node-rockpi4.patch; }
        ];
        extraConfig =
          ''
          PCIE_ROCKCHIP y
          PCIE_ROCKCHIP_HOST y
          PCIE_DW_PLAT y
          PCIE_DW_PLAT_HOST y
          PHY_ROCKCHIP_PCIE y
          '';
      };
    };

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_rockpi4;
  # boot.initrd.availableKernelModules = [ "nvme" "pcie-rockchip-host" ];
  # boot.kernelModules = [ "pcie-rockchip-host" ];

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enabled = true;

  # fileSystems."/db" = {
  #   device = "/dev/disk/by-label/DB";
  #   fsType = "ext4";
  # };

  # log to tmpfs
  # fileSystems."/var/log" = {
  #   device = "tmpfs";
  #   fsType = "tmpfs";
  #   neededForBoot = true;
  # };

  networking.firewall.enable = true;

  # Since 20.03, you must explicitly specify to use dhcp on an interface
  networking.interfaces.eth0.useDHCP = true;
}