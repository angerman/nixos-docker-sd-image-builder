{ config, pkgs, lib, ... }:
{
  imports = [
    ../config/rpi3
    ../shared/common.nix
    ../shared/pkgs/networking/pihole/service.nix
    ../shared/pkgs/networking/pihole-admin/service.nix
    ../shared/wireless.nix
    ../shared/wireguard.nix
  ];

  nixpkgs.overlays = [
    (import ../shared/overlays/pihole.nix)
  ];

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enable = true;

  services.pihole-ftl.enable = true;
  services.pihole-ftl.interface = "eth0";
  services.pihole-admin.enable = true;
  systemd.services.phpfpm-pihole-admin.serviceConfig.PrivateDevices = lib.mkOverride 40 false;

  # fileSystems."/db" = {
  #   device = "/dev/disk/by-label/DB";
  #   fsType = "ext4";
  # };
  # log to tmpfs
  fileSystems."/var/log" = {
    device = "tmpfs";
    fsType = "tmpfs";
    neededForBoot = true;
  };

  networking.firewall.enable = true;

  environment.systemPackages = [ pkgs.pihole-scripts pkgs.sqlite ];

}