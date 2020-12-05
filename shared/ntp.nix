{ ... }:
{
  # NTP time sync.
  services.timesyncd.enable = true;
  services.timesyncd.extraConfig = ''
    PollIntervalMinSec=16
    PollIntervalMaxSec=32
  '';
}