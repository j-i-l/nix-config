{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib appimageTools fetchurl gtk3 gsettings-desktop-schemas;
  version = "2.0.1";
  pname = "kMeet";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://download.storage5.infomaniak.com/meet/kmeet-desktop-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-0lygBbIwaEydvFEfvADiL2k5GWzVpM1jX4orweriBYw=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "kMeet.md appImage";
    longDescription = ''
       The latest build of kMeet, in appImage form, suitably nixed
    '';
    homepage = https://www.infomaniak.com/en/apps/download-kmeet;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
