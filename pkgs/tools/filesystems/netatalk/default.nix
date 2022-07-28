{ fetchurl, lib, stdenv, autoreconfHook, pkg-config, perl, python3
, db, libgcrypt, avahi, libiconv, pam, openssl, acl
, ed, libtirpc, libevent, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "netatalk";
  version = "3.1.12";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${version}.tar.bz2";
    sha256 = "sha256-FWD4Oj2kG+l+C3CpbiQCFZuN3GMdOFODYLFHhL6tpdE=";
  };

  patches = [
    ./no-suid.patch
    ./omitLocalstatedirCreation.patch
    (fetchpatch {
      name = "make-afpstats-python3-compatible.patch";
      url = "https://github.com/Netatalk/Netatalk/commit/916b515705cf7ba28dc53d13202811c6e1fe6a9e.patch";
      sha256 = "sha256-DAABpYjQPJLsQBhmtP30gA357w0Qn+AsnFgAeyDC/Rg=";
    })
    (fetchpatch {
      name = "netatalk-3.1.12-fno-common.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-fs/netatalk/files/netatalk-3.1.12-fno-common.patch?id=233aa32334f7ed86ac66897f9edd47f221bc299f";
      sha256 = "sha256-/nxS3w9uBG4uZ0rJn9RjLORhvhupzQP91AAza5mzhV0=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config perl python3 python3.pkgs.wrapPython ];

  buildInputs = [ db libgcrypt avahi libiconv pam openssl acl libevent ];

  configureFlags = [
    "--with-bdb=${db.dev}"
    "--with-ssl-dir=${openssl.dev}"
    "--with-lockfile=/run/lock/netatalk"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var/lib"
  ];

  # Expose librpcsvc to the linker for afpd
  # Fixes errors that showed up when closure-size was merged:
  # afpd-nfsquota.o: In function `callaurpc':
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_args'
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_rslt'
  postConfigure = ''
    ${ed}/bin/ed -v etc/afpd/Makefile << EOF
    /^afpd_LDADD
    /am__append_2
    a
      ${libtirpc}/lib/libtirpc.so \\
    .
    w
    EOF
  '';

  postInstall = ''
    buildPythonPath ${python3.pkgs.dbus-python}
    patchPythonScript $out/bin/afpstats
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = "http://netatalk.sourceforge.net/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
