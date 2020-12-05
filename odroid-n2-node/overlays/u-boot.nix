final: prev: {
    ubootOdroidN2 =
        let plat = if true || builtins.currentSystem == "aarch64-linux" then prev
        else prev.pkgsCross.aarch64-multiplatform; in
        plat.buildUBoot {
            version = "v2020.04.20";
            # See https://gitlab.denx.de/u-boot/custodians/u-boot-amlogic/-/commit/6de936b011fb02d1019a69aea0184cee4a578f59
            # that's the first commit that introduces reading the ethaddr from the efuse!
            src = prev.fetchFromGitLab {
                domain = "gitlab.denx.de";
                owner = "u-boot/custodians";
                repo = "u-boot-amlogic";
                rev = "6de936b011fb02d1019a69aea0184cee4a578f59";
                sha256 = "19jkmnmvd6758j55bjvh0dimjw9j776y6m8y4xjngpypvfgzsclc";
            };
            extraConfig = ''
            '';
            extraPatches = [
            ];
            defconfig = "odroid-n2_defconfig";
            extraMeta.platforms = [ "aarch64-linux" ];
            filesToInstall = [ "u-boot.bin" ".config" ];
        };
}