{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "pihole-admin";
  version = "v5.1.1";

  src = fetchzip {
    url = "https://github.com/pi-hole/AdminLTE/archive/${version}.tar.gz";
    sha256 = "1cr9x006rwii0dska9w9b3r0sji5pgnyql26jv7l46j6k0nf57z8";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/$name/www
    cp *.php $out/share/$name/www
    cp .user.php.ini $out/share/$name/www
    cp -r scripts $out/share/$name/www
    cp -r img $out/share/$name/www
    cp -r style $out/share/$name/www
    substituteInPlace $out/share/$name/www/scripts/pi-hole/php/func.php \
      --replace 'trigger_error("Executing {''$command} failed.", E_USER_WARNING);' \
                'trigger_error("Executing {''$command} failed. {''$return_status}", E_USER_WARNING);'
  '';

  meta = with stdenv.lib; {
    description = "Pi-hole AdminLTE web UI";
    homepage = "https://github.com/pi-hole/AdminLTE";
    license = licenses.eupl11; ## TODO eupl12
    maintainers = with maintainers; [ angerman ];
    platforms = platforms.all;
  };
}