{ stdenv, uboot, meson64-tools, ... }:
stdenv.mkDerivation {
    name = "Firmware-Image-Package";

    src = ./.;

    UBOOT="${uboot}/u-boot.bin";

    makeFlags = [ "PREFIX=$(out)" ];

    nativeBuildInputs = [ meson64-tools ];
}