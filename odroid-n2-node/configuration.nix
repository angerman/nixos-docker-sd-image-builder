{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    ../shared/common.nix
  ];

  nixpkgs.overlays = [
    (import ./overlays/u-boot.nix)
    (import ./overlays/meson64-tools.nix)
    (import ./overlays/fip.nix)
    # (import ./overlays/kernel.nix)
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelParams = [ "console=ttyAML0,115200n8" ];

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;

  # https://lkml.org/lkml/2020/3/20/57 (example build script)
  # https://github.com/wav/nix-odroid-n2/blob/master/packages/uboot_odroid_n2/default.nix (example)
  # odroid c2: https://github.com/NixOS/nixpkgs/pull/75069/files
  #

  nixpkgs.config.packageOverrides = pkgs:
    { linux_odroid_n2 = pkgs.linux_5_6.override {
        kernelPatches = [
          # { name = "dts:rockchip-add-pcie-node"; patch = ./manjaro-linux-aarch64/0001-arm64-dts-rockchip-add-pcie-node-rockpi4.patch; }
        ];
        extraConfig =
          ''
          ARCH_MESON y
          PCI_MESON y
          SERIAL_MESON y
          MESON_EFUSE y
          MESON_MX_EFUSE y
          BLK_DEV_DM_BUILTIN y
          '' +
          # the following two are necessary, for
          # the boot process not to get stuck on
          # reading the RTC.
          ''
          AMLOGIC_I2C_MASTER y
          RTC_DRV_PCF8563 y
          '' +
          # Make sure we have thermals and PWM
          ''
          AMLOGIC_THERMAL y
          PWM_MESON y
          '';

          # MESON_SM y
          # PCI_MESON y
          # MTD_NAND_MESON y
          # DWMAC_MESON y
          # MDIO_BUS_MUX_MESON_G12A y
          # SERIAL_MESON y
          # SERIAL_MESON_CONSOLE y
          # HW_RANDOM_MESON y
          # I2C_MESON y
          # SPI_MESON_SPICC y
          # SPI_MESON_SPIFC y
          # PINCTRL_MESON y
          # PINCTRL_MESON_GXBB y
          # PINCTRL_MESON_GXL y
          # PINCTRL_MESON8_PMX y
          # PINCTRL_MESON_AXG y
          # PINCTRL_MESON_AXG_PMX y
          # PINCTRL_MESON_G12A y
          # PINCTRL_MESON_A1 y
          # MESON_GXBB_WATCHDOG y
          # MESON_WATCHDOG y
          # IR_MESON y
          # VIDEO_MESON_AO_CEC y
          # VIDEO_MESON_G12A_AO_CEC m
          # USB_DWC3_MESON_G12A y
          # MMC_MESON_GX y
          # MMC_MESON_MX_SDIO y
          # RTC_DRV_MESON_VRTC m
          # VIDEO_MESON_VDEC m
          # COMMON_CLK_MESON_REGMAP y
          # COMMON_CLK_MESON_DUALDIV y
          # COMMON_CLK_MESON_MPLL y
          # COMMON_CLK_MESON_PLL y
          # COMMON_CLK_MESON_VID_PLL_DIV y
          # COMMON_CLK_MESON_AO_CLKC y
          # COMMON_CLK_MESON_EE_CLKC y
          # COMMON_CLK_MESON_CPU_DYNDIV y
          # MESON_CANVAS m
          # MESON_CLK_MEASURE y
          # MESON_GX_SOCINFO y
          # MESON_GX_PM_DOMAINS y
          # MESON_EE_PM_DOMAINS y
          # MESON_SECURE_PM_DOMAINS y
          # MESON_MX_SOCINFO y
          # MESON_SARADC y
          # PWM_MESON y
          # MESON_IRQ_GPIO y
          # RESET_MESON y
          # PHY_MESON_G12A_USB2 y
          # PHY_MESON_G12A_USB3_PCIE y
      };
    };

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_odroid_n2;


  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enabled = true;

  # log to tmpfs
  # fileSystems."/var/log" = {
  #   device = "tmpfs";
  #   fsType = "tmpfs";
  #   neededForBoot = true;
  # };

  # the odroid doesn't have any wireless
  networking.wireless.enable = lib.mkOverride 40 false;

  networking.firewall.enable = true;

  # Since 20.03, you must explicitly specify to use dhcp on an interface
  networking.interfaces.eth0.useDHCP = true;
}