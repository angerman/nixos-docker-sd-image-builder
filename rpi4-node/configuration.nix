{ config, pkgs, lib, ... }:
{
  imports = [
    ../config/rpi4
    ../shared/common.nix
    ../shared/wireless.nix
    ../shared/cardano-node.nix
  ];

  # OpenSSH is forced to have an empty `wantedBy` on the installer system[1], this won't allow it
  # to be automatically started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];

  # Enable OpenSSH out of the box.
  services.sshd.enabled = true;

  # log to tmpfs
  fileSystems."/var/log" = {
    device = "tmpfs";
    fsType = "tmpfs";
    neededForBoot = true;
  };

  networking.firewall.enable = true;

}