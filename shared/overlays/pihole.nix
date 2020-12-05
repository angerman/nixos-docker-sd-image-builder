final: prev:
{
    pihole-ftl     = prev.callPackage ../pkgs/networking/pihole/ftl.nix {};
    pihole-admin   = prev.callPackage ../pkgs/networking/pihole/admin.nix {};
    pihole-scripts = prev.callPackage ../pkgs/networking/pihole/pihole.nix {};
}