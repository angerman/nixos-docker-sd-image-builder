final: prev: {
    ubootRockPi4 =
        let plat = if true || builtins.currentSystem == "aarch64-linux" then prev
        else prev.pkgsCross.aarch64-multiplatform; in
        plat.buildUBoot {
            # Upstream defconfig https://gitlab.denx.de/u-boot/u-boot/blob/master/configs%2Frock-pi-4-rk3399_defconfig
            # Radxa's for the rockpi4b: https://github.com/radxa/u-boot/blob/stable-4.4-rockpi4/configs/rock-pi-4b-rk3399_defconfig
            # For the all rockpis have the same ethernet address see:
            # https://forum.radxa.com/t/ethaddr-all-the-same-after-moving-to-mainline-u-boot/2355
            # And specifically https://forum.radxa.com/t/ethaddr-all-the-same-after-moving-to-mainline-u-boot/2355/7
            #
            # cf: https://github.com/armbian/build/pull/1660/files
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
                ../patches/uboot/115200baud.patch
            ];
            defconfig = "rock-pi-4-rk3399_defconfig";
            extraMeta.platforms = [ "aarch64-linux" ];
            BL31 = "${plat.armTrustedFirmwareRK3399}/bl31.elf";
            filesToInstall = ["idbloader.img" "u-boot.itb" ".config"];
        };
}