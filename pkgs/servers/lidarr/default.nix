{ lib, fetchFromGitHub, buildDotnetModule, dotnetCorePackages, libmediainfo, openssl, sqlite, curl, chromaprint, nodejs, yarn, tree }:

buildDotnetModule rec {
  pname = "lidarr";
  version = "1.1.0.2649";

  src = fetchFromGitHub {
    owner = "Lidarr";
    repo = "Lidarr";
    rev = "v${version}";
    sha256 = "sha256-toBQ/0BXBqf/cCKmQkgtXBJypaKeS2toHfv17sMRs/8=";
  };

  buildInputs = [ nodejs yarn tree ];
  dotnetFlags = [ "-p:RuntimeIdentifiers=linux-x64" "-p:Deterministic=false" "-p:TargetFramework=net6.0" ];
  executables = [ "Lidarr" ];
  nugetDeps = ./deps.nix;
  projectFile = "src/Lidarr.sln";
  runtimeDeps = [ libmediainfo openssl sqlite curl chromaprint ];
  selfContainedBuild = true;

  preConfigure = ''
    yarn install --frozen-lockfile --network-timeout 120000
    yarn run build --env production
    mkdir -p $out/lib/lidarr
    cp -r _output/UI $out/lib/lidarr
  '';

  meta = with lib; {
    description = "A Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    platforms = platforms.all;
  };
}
