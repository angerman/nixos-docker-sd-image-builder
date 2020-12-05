{ lib, ... }:
with import ../secrets.nix;
{
  # Wireless networking (1). You might want to enable this if your Pi is not attached via Ethernet.
  networking.wireless = {
   enable = true;
   interfaces = [ "wlan0" ];
   networks = {
     "${wlan-ssid}" = {
       psk = wlan-psk;
     };
   };
  };

  # Wireless networking (2). Enables `wpa_supplicant` on boot.
  systemd.services.wpa_supplicant.wantedBy = lib.mkOverride 10 [ "default.target" ];
}