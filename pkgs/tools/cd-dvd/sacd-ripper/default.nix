{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "sacd-ripper";
  version = "0.3.9";

  src = fetchFromGitHub {
    hash = "sha256-qpH4HfX5Upjknd58UpVClFrFilfvRvI3j1/THeM3vNE=";
    owner = "setmind";
    repo = "sacd-ripper";
    rev = "${version}@setmind";
  };

  meta = with lib; {
    description = "SACD Ripper";
    homepage = "https://github.com/setmind/sacd-ripper";
    license = licenses.gpl2;
    maintainers = [ maintainers.lovek323 ];
    platforms = [ "x86_64-linux" ];
  };

  buildInputs = [
    cmake
  ];

  configurePhase = ''
    cd tools/sacd_extract
    cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_C_FLAGS="-fcommon" .
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sacd_extract $out/bin
  '';
}
