{ stdenv, lib, coreutils }:
stdenv.mkDerivation {
    name = "helios64-udev-usb-net";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
        mkdir -p "$out/etc/udev/rules.d/";
        install -Dm644 "${../../../armbian/packages/bsp/helios64/50-usb-realtek-net.rules}"        "$out/etc/udev/rules.d/50-usb-realtek-net.rules"
        install -Dm644 "${../../../armbian/packages/bsp/helios64/70-keep-usb-lan-as-eth1.rules}"   "$out/etc/udev/rules.d/70-keep-usb-lan-as-eth1.rules"
        substituteInPlace "$out/etc/udev/rules.d/50-usb-realtek-net.rules" \
            --replace '/bin/ln'  '${lib.getBin coreutils}/bin/ln'
    '';

    meta = with stdenv.lib; {
        description = "USB NET for Helios64";
        longDescription = ''
            To install udev rules, add `services.udev.packages = [ helios64-udev-usb-net ]`
            into `nixos/configuration.nix`.
        '';
        platforms = platforms.linux;
        maintainers = with maintainers; [ angerman ];
    };
}