{ lib, stdenv, fetchurl, flac }:

stdenv.mkDerivation {
  version = "3.0.10-2";
  pname = "shntool";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/s/shntool/shntool_3.0.10.orig.tar.gz";
    sha256 = "sha256-dDAurEd8oI+ytCufFUzIcFk67IvqswhnbkNzpeTKIQI=";
  };

  buildInputs = [ flac ];

  patches = [
    ./debian/patches/large-size.patch
    ./debian/patches/large-times.patch
    ./debian/patches/no-cdquality-check.patch
  ];

  meta = {
    description = "Multi-purpose WAVE data processing and reporting utility";
    homepage = "http://www.etree.org/shnutils/shntool/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
