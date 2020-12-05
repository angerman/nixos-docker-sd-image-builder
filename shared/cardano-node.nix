{ ... }:
{
  networking.firewall.allowedTCPPorts = [
     3001 # cardano-node
    12788 # ekg
    12798 # prometheus (relay)
    12799 # prometheus (pool)
  ];

  fileSystems."/db" = {
    device = "/dev/disk/by-label/DB";
    fsType = "ext4";
  };
}