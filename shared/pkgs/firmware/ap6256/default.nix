#
# Support for the AP6256 chip, found for example
# on the RockPi 4 sold by radxa.
#
# The firmware blobs have been extraced from manjaro-arm
# which seemed to have the most recent.
#
# Specifically at:
# https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firmware/-/commit/761ff450905c4f685481414341f9f4c321ed016b
#
# The fw_bcm43456c5_ag.bin should include the Kr00k fix, as the hases match for
# the armbian after this one was merged https://github.com/StephenInVamrs/firmware/commit/2a7e18f05305277c9fb22443c6343ad3fa1d2f5d
{ stdenv }:
stdenv.mkDerivation {
  pname = "ap6256-firmware";
  version = "2020.20";

  dontUnpack = true;
  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  installPhase = ''
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    install -Dm644 "${./fw_bcm43456c5_ag.bin}"        "$out/lib/firmware/brcm/brcmfmac43456-sdio.bin"
    install -Dm644 "${./brcmfmac43456-sdio.clm_blob}" "$out/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob"
    install -Dm644 "${./nvram_ap6256.txt}"            "$out/lib/firmware/nvram_ap6256.txt"
    install -Dm644 "${./nvram_ap6256.txt}"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.txt"
    install -Dm644 "${./nvram_ap6256.txt}"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.radxa,rockpi4.txt"
    install -Dm644 "${./nvram_ap6256.txt}"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.pine64,pinebook-pro.txt"

    # Bluetooth firmware
    install -Dm644 "${./BCM4345C5.hcd}"               "$out/lib/firmware/BCM4345C5.hcd"
    install -Dm644 "${./BCM4345C5.hcd}"               "$out/lib/firmware/brcm/BCM.hcd"
    install -Dm644 "${./BCM4345C5.hcd}"               "$out/lib/firmware/brcm/BCM4345C5.hcd"
  '';

  meta = with stdenv.lib; {
    description = "Firmware for AP6256";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ angerman ];
  };
}
