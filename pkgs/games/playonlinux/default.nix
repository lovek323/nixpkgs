{ stdenv, fetchurl, gettext, wget, which, python, makeWrapper, pythonPackages
, bash, cabextract, gnupg1, icoutils, p7zip }:

stdenv.mkDerivation {
  name = "playonlinux-4.2.1";

  src = fetchurl {
    url    = "https://github.com/PlayOnLinux/POL-POM-4/archive/4.2.1.tar.gz";
    sha256 = "16kbnidv8mzyihpd7xq0h1dkng8ba0kwkkcdhpaiv4ap1w2fmg4b";
  };

  meta = with stdenv.lib; {
    description = "Easily install Windows games on Linux";
    homepage    = http://www.playonlinux.com;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/share/playonlinux"
    cp -r * "$out/share/playonlinux"
    mkdir "$out/bin"
    printf "#!${bash}/bin/bash\ncd \"$out/share/playonlinux\"\n./playonlinux-url_handler \"\$@\"" > "$out/bin/playonlinux-url_handler"
    chmod u+x "$out/bin/playonlinux-url_handler"

    for prog in "playonlinux" "playonlinux-url_handler" "playonlinux-bash"; do
      wrapProgram "$out/share/playonlinux/$prog" \
        --prefix PATH : "${cabextract}/bin:${gettext}/bin:${gnupg1}/bin:${icoutils}/bin:${p7zip}/bin:${python}/bin:${wget}/bin:${which}/bin" \
        --prefix PYTHONPATH : "${pythonPackages.wxPython}/lib/python2.7/site-packages"
    done
  '';
}
