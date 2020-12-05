{ stdenv, fetchurl, pkgconfig, dbus, nettle, fetchpatch
, gmp, libidn, libnetfilter_conntrack, cmake }:

with stdenv.lib;
let
  copts = concatStringsSep " " ([
    "-DHAVE_IDN"
    "-DHAVE_DNSSEC"
  ] ++ optionals stdenv.isLinux [
    "-DHAVE_DBUS"
    "-DHAVE_CONNTRACK"
  ]);
in
stdenv.mkDerivation rec {
  version = "5.2";
  name = "pihole-ftl-${version}";

  gitRef    = "dbd4a696afd35efa5e6c4882c74d9102d9d7d6a2";
  gitBranch = "master";
  gitTag    = "v${version}";
  gitDate   = "2020-07-06 08:55:25 +0200";

  src = fetchurl {
    url = "https://github.com/pi-hole/FTL/archive/v${version}.tar.gz";
    sha256 = "0m97a6hjxw3g1l1r0jsqgrqvrzkknlx6jqd0yqk1lkd0q9pahw0x";
  };

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
    sed '1i#include <linux/sockios.h>' -i src/dnsmasq/dhcp.c
    sed 's/''${CMAKE_STATIC_LIBRARY_SUFFIX}/.so/g' -i src/CMakeLists.txt
    cat src/CMakeLists.txt
  '';

  preBuild = ''
    makeFlagsArray=("COPTS=${copts}")
    # override git variables
    makeFlagsArray+=(GIT_HASH="${gitRef}")
    makeFlagsArray+=(GIT_BRANCH="${gitBranch}")
    makeFlagsArray+=(GIT_VERSION="${gitTag}")
    makeFlagsArray+=(GIT_TAG="${gitTag}")
    makeFlagsArray+=(GIT_DATE="${gitDate}")
  '';

  makeFlags = [
    "DESTDIR="
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/man"
    "LOCALEDIR=$(out)/share/locale"
  ];

  hardeningEnable = [ "pie" ];

  # XXX: Does the systemd service definition really belong here when our NixOS
  # module can create it in Nix-land?

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ nettle libidn gmp ]
    ++ optionals stdenv.isLinux [ dbus libnetfilter_conntrack ];

  meta = {
    description = "Pi-hole FTLDNS - Network-wide ad blocking via your own Linux hardware";
    homepage = "http://pi-hole.net";
    license = licenses.gpl2; # this is eupl, but nix doesn't know about it.
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ angerman ];
  };
}