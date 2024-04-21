{ lib, stdenv, fetchzip, autoPatchelfHook, taglib }:

let
  pname = "metadsf";
  version = "0.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  buildInputs = [ taglib ];

  nativeBuildInputs = [ autoPatchelfHook ];

  src = fetchzip {
    url = "https://github.com/pekingduck/metadsf/releases/download/v0.1/metadsf-linux64.zip";
    sha256 = "sha256-qF0Y0wdPeXXFa6bmwkJ28soNqduj+UPjpHS5KOm9VS4=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv metadsf $out/bin
  '';

  runtimeDependencies = [ taglib ];

  meta = with lib; {
    description = "a command line tool that lets you batch-edit ID3v2 tags embedded in your DSF files.";
    mainProgram = "metadsf";
    homepage = "https://github.com/pekingduck/metadsf";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.linux;
  };
}
