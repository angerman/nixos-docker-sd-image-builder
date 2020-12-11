{ stdenv, lib, coreutils }:
stdenv.mkDerivation {
    name = "helios64-udev-fancontrol";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
        mkdir -p "$out/etc/udev/rules.d/";
        install -Dm644 "${../../../armbian/packages/bsp/helios64/90-helios64-hwmon.rules}"        "$out/etc/udev/rules.d/90-helios64-hwmon.rules"
        substituteInPlace "$out/etc/udev/rules.d/90-helios64-hwmon.rules" \
            --replace '/bin/ln'  '${lib.getBin coreutils}/bin/ln'
    '';

    meta = with stdenv.lib; {
        description = "fancontrol for Helios64";
        longDescription = ''
            To install udev rules, add `services.udev.packages = [ helios64-udev-fancontrol ]`
            into `nixos/configuration.nix`.
        '';
        platforms = platforms.linux;
        maintainers = with maintainers; [ angerman ];
    };
}