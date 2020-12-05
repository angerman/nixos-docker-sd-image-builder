final: prev: {
    ubootHelios64 =
        let plat = if true || builtins.currentSystem == "aarch64-linux" then prev
        else prev.pkgsCross.aarch64-multiplatform; in
        plat.buildUBoot {
            # version = "v2020.04.20";
            # See https://gitlab.denx.de/u-boot/custodians/u-boot-amlogic/-/commit/6de936b011fb02d1019a69aea0184cee4a578f59
            # that's the first commit that introduces reading the ethaddr from the efuse!
            # src = fetchTarball {
            #     url = "https://github.com/kobol-io/u-boot/archive/29d63b29550818992e3bcdb1ceb2a0db49d395cc.tar.gz";
            #     sha256 = "1lxyjlssalc0c6nxaw2h8xxmazphmqdp4z8lz947s7v2cmbkmgd5";
            # };
            extraConfig = ''
            # The default 1_500_000 doesn't work with anything but ftdi modems
            # apparently, and all I got are CP2102 and PL2303HX. 1_500_000 isn't
            # listed as a supported baudrate, 115_200 is though.
            CONFIG_BAUDRATE=115200
            # This one is needed to obtain the cpu-id;
            CONFIG_MISC=y
            CONFIG_ROCKCHIP_EFUSE=y
            # which in turn is used to derive the mac address.
            CONFIG_MISC_INIT_R=y
            '';
            extraPatches = [
                ../patches/uboot/add-board-helios64.patch
                ../patches/uboot/115200baud.patch
            ];
            defconfig = "helios64-rk3399_defconfig";
            extraMeta.platforms = [ "aarch64-linux" ];
            BL31 = "${plat.armTrustedFirmwareRK3399}/bl31.elf";
            filesToInstall = ["idbloader.img" "u-boot.itb" ".config"];
        };
}