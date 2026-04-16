{ config, pkgs, ... }:

let
  pname = "limux";
  version = "0.1.13";
  # Providing the direct URL for v0.1.13 as requested
  linkAppImageURL = "https://github.com/am-will/limux/releases/download/v${version}/Limux-${version}-x86_64.AppImage";
  
  # Replace this with the actual SHA you have
  sha = "sha256-y/QMnLWFPA2fDkp9/yCTyYkzoUjx3IAjNO9Rz6Ms3Hs="; 

  src = pkgs.fetchurl {
    url = linkAppImageURL;
    sha256 = sha;
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  limux = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    # These are the "System Dependencies" we discovered earlier
    extraPkgs = pkgs: with pkgs; [
      gtk4
      libadwaita
      webkitgtk_6_0
      libglvnd # Added for GPU acceleration support (Ghostty engine)
    ];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      # Extract icon from the AppImage contents
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${appimageContents}/usr/share/icons/hicolor/512x512/apps/limux.png $out/share/icons/hicolor/512x512/apps/${pname}.png || true
      
      cat > $out/share/applications/${pname}.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Limux
      Icon=${pname}
      Exec=${pname} %F
      StartupWMClass=dev.limux.linux
      Categories=System;TerminalEmulator;
      Comment=GPU-accelerated terminal workspace manager
      EOF
    '';
  };

in
{
  home.packages = [
    limux
  ];
}