final: prev: {
  linux_odroid_n2_4_9 = final.callPackage ../packages/linux_odroid_n2/linux-hardkernel-4.9.nix {};
  linux_odroid_n2_5_4 = final.callPackage ../packages/linux_odroid_n2/linux-5.4.nix {};
  linux_odroid_n2_5_5 = final.callPackage ../packages/linux_odroid_n2/linux-5.5.nix {};
  linux_odroid_n2_5_6 = final.callPackage ../packages/linux_odroid_n2/linux-5.6.nix {};
}
