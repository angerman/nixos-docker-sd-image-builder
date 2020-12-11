{ pkgs, ... }:
{
    systemd.services.helios64-ups = {
        enable = true;
        description = "Helios64 UPS Action";
        serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.systemd}/bin/poweroff";
        };
    };

    systemd.timers.helios64-ups = {
        enable = true;
        description = "Helios64 UPS Shutdown timer on power loss";
        # disabling the timer by default. Even though armbian enaled
        # the timer by default through this, we don't, as we can't
        # rely on the udev rules to disable it after a system switch.
        # wantedBy = [ "multi-user.target" ];
        timerConfig = {
            OnActiveSec = "10m";
            AccuracySec = "1s";
            Unit = "helios64-ups.service";
        };
    };
    # The udev rule that will trigger the above service.
    services.udev.packages =
        [
            (pkgs.callPackage ../pkgs/udev/ups.nix {})
        ];
}