{ stdenv, lib, coreutils, systemd }:
stdenv.mkDerivation {
    name = "helios64-udev-ups";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
        mkdir -p "$out/etc/udev/rules.d/";
        install -Dm644 "${../../../armbian/packages/bsp/helios64/90-helios64-ups.rules}"        "$out/etc/udev/rules.d/90-helios64-ups.rules"
        substituteInPlace "$out/etc/udev/rules.d/90-helios64-ups.rules" \
            --replace '/bin/ln'  '${lib.getBin coreutils}/bin/ln' \
            --replace '/usr/bin/systemctl' '${lib.getBin systemd}/bin/systemctl'
    '';

    meta = with stdenv.lib; {
        description = "UPS for Helios64";
        longDescription = ''
            To install udev rules, add `services.udev.packages = [ helios64-udev-ups ]`
            into `nixos/configuration.nix`.
        '';
        platforms = platforms.linux;
        maintainers = with maintainers; [ angerman ];
    };
}