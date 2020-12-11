{ pkgs, ... }:
{
    # See https://github.com/armbian/build/blob/eeba7e3d73c7802ea7a455a949305d1d5bc8f365/packages/bsp/helios64/fancontrol.conf
    environment.etc."fancontrol".text = ''
    # Helios64 PWM Fan Control Configuration
    # Temp source : /dev/thermal-cpu
    INTERVAL=10
    FCTEMPS=/dev/fan-p6/pwm1=/dev/thermal-cpu/temp1_input /dev/fan-p7/pwm1=/dev/thermal-cpu/temp1_input
    MINTEMP=/dev/fan-p6/pwm1=40 /dev/fan-p7/pwm1=40
    MAXTEMP=/dev/fan-p6/pwm1=80 /dev/fan-p7/pwm1=80
    MINSTART=/dev/fan-p6/pwm1=60 /dev/fan-p7/pwm1=60
    MINSTOP=/dev/fan-p6/pwm1=29 /dev/fan-p7/pwm1=29
    MINPWM=20
    '';

    # See https://www.codedbearder.com/posts/nixos-terramaster-f2-221/
    systemd.services.fancontrol = {
        enable = true;
        description = "Fan control";
        wantedBy = ["multi-user.target" "graphical.target" "rescue.target"];

        unitConfig = {
            Type = "simple";
        };

        serviceConfig = {
            ExecStart = "${pkgs.lm_sensors}/bin/fancontrol";
            Restart = "always";
        };
    };
    services.udev.packages =
        [
            (pkgs.callPackage ../pkgs/udev/fancontrol.nix {})
        ];
}