{ stdenv, fetchurl, python, buildPythonPackage, gmp, gnused }:

buildPythonPackage rec {
  name = "pycrypto-2.6.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pycrypto/${name}.tar.gz";
    sha256 = "0g0ayql5b9mkjam8hym6zyg6bv77lbh66rv1fyvgqb17kfc1xkpj";
  };

  buildInputs =
    stdenv.lib.optional (!python.isPypy or false) gmp # optional for pypy
    ++ stdenv.lib.optional stdenv.isDarwin gnused;

  doCheck = !(python.isPypy or stdenv.isDarwin); # error: AF_UNIX path too long

  # prevent certain include files from being included twice
  postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i "s|include_dirs=\\['src/','/usr/include/'\\]|include_dirs=['src/']|" setup.py
  '';

  meta = {
    homepage = "http://www.pycrypto.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
