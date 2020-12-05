{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/profiles/installation-device.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    ../shared/common.nix
  ];

  nixpkgs.overlays = [
    (import ./overlays/u-boot.nix)
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelParams = [
    "cma=32M"
    # "console=ttyS0,115200n8"
    # "console=ttyS1,115200n8"
    "console=ttyS2,115200n8"
    "earlycon=uart8250,mmio32,0xff1a0000"
    "earlyprintk"
  ];


  nixpkgs.config.packageOverrides = pkgs:
    { linux_helios64 = pkgs.linux_5_8.override {
        kernelPatches = [
          # these patches are from https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/log/?h=v5.11-armsoc/dts64
          # maybe we should just grab the armbian rock64 ones?
          # https://github.com/armbian/build/tree/master/patch/kernel/rockchip64-current
          { name = "dt-bindings: vendor-prefixes: Add kobol prefix"; patch = ./patches/kernel/fa67f2817ff2c9bb07472d30e58d904922f1a538.patch; }
          { name = "arm64: dts: rockchip: Add basic support for Kobol's Helios64"; patch = ./patches/kernel/09e006cfb43e8ec38afe28278b210dab72e6cac8.patch; }
          { name = "dt-bindings: arm: rockchip: Add Kobol Helios64"; patch = ./patches/kernel/62dbf80fc581a8eed7288ed7aca24446054eb616.patch; }
        ];
        extraConfig =
          ''
          INPUT_GPIO_BEEPER m
          GPIO_PCA953X y
          GPIO_PCA953X_IRQ y
          GENERIC_ADC_BATTERY m
          '';
    };
  };

  sdImage = {
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_helios64;
  # boot.initrd.availableKernelModules = [ "nvme" "pcie-rockchip-host" ];
  # boot.kernelModules = [ "pcie-rockchip-host" ];

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enable = true;

  networking.firewall.enable = true;

  # Since 20.03, you must explicitly specify to use dhcp on an interface
  networking.interfaces.eth0.useDHCP = true;
}