{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, gnum4
}:

stdenv.mkDerivation rec {
  pname = "libdvd-audio";
  version = "1.0.0";

  src = fetchFromGitHub {
    hash = "sha256-zFeE4jK0zwS1KmbRQQTIzzcMz4oB0drTMVlq1JQGW6w=";
    owner = "tuffy";
    repo = "libdvd-audio";
    rev = "v${version}";
  };

  buildInputs = [
    gnum4
  ];

  installPhase = ''
    sed -i "s#/usr/local#$out#" Makefile
    sed -i "s#/usr/lib#$out#" Makefile
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    mkdir -p "$out/include"
    make install
  '';

  meta = with lib; {
    description = "libdvd-audio";
    longDescription = "libdvd-audio";
    homepage = "https://github.com/tuffy/libdvd-audio";
    license = licenses.gpl2;
    maintainers = [ maintainers.lovek323 ];
    platforms = [ "x86_64-linux" ];
  };
}
