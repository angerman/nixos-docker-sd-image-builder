{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "pihole-scripts";
  version = "v5.1.2";

  src = fetchzip {
    url = "https://github.com/pi-hole/pi-hole/archive/${version}.tar.gz";
    sha256 = "0ncgnxxkp8lmahc56smxcwsi5zgf1hzzqs4ishjvybm085ndxaps";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp pihole $out/bin
    cp gravity.sh $out/bin
    cp -r advanced/Scripts/* $out/bin

    mkdir -p $out/share
    cp -r advanced $out/share

    substituteInPlace $out/bin/pihole \
      --replace "/opt/pihole" "$out/bin" \
      --replace "/etc/.pihole" $out/share \
      --replace "/usr/local/bin" "$out/bin"

    for script in $(find $out -name "*.sh"); do
        substituteInPlace $script \
          --replace "/opt/pihole" "$out/bin" \
          --replace "/etc/.pihole" $out/share \
          --replace "/usr/local/bin" "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
      description = "Pi-hole scripts";
      homepage = "https://github.com/pi-hole/pi-hole";
      license = licenses.eupl11;
      maintainers = with maintainers; [ angerman ];
      platforms = platforms.all;
  };
}