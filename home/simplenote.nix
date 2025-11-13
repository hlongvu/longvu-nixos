 { config, pkgs, ... }:

let
  # --- Simplenote AppImage Details ---
  simplenoteVersion = "2.23.2";
  # NOTE: Replace the placeholder SHA with the correct one.
  # Use an incorrect one initially, run 'nixos-rebuild switch', and copy
  # the 'got' hash from the error message.
  simplenoteSHA = "sha256-kY8ZiDbPHYJiCobL0tnap6Ns4H5qav226FLa4tHT5xM=";
  name = "simplenote";
  pname = "simplenote"; # Required by appimageTools.extract
  version = "2.23.2";
  simplenoteAppImageURL = "https://github.com/Automattic/simplenote-electron/releases/download/v${simplenoteVersion}/Simplenote-linux-${simplenoteVersion}-x86_64.AppImage";

  src = pkgs.fetchurl {
      url = "${simplenoteAppImageURL}";
      sha256 = "${simplenoteSHA}";
    };

  # --- Fix applied here: Added 'pname' to inherit or explicitly pass ---
  appimageContents = pkgs.appimageTools.extract {
	# You must include pname here
	inherit src version pname;
  };
  # --- Build Simplenote from AppImage ---
  simplenote = pkgs.appimageTools.wrapType2 {
    inherit src name pname version;
    # Add a .desktop entry for GUI launchers
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      local icon_size="512x512" # A common size for Electron AppImages
      mkdir -p $out/share/icons/hicolor/$icon_size/apps
      cp ${appimageContents}/${name}.png $out/share/icons/hicolor/$icon_size/apps/${name}.png
      cat > $out/share/applications/${name}.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Simplenote
      Icon=simplenote.png
      Exec=simplenote %F
      Categories=Office;Utility;TextEditor;
      Comment = "A simple, light, and free note-taking application."
      EOF
    '';

    # The application itself usually provides an icon inside the AppImage.
    # If the app doesn't show an icon, you might need an 'icon' derivation
    # similar to the XnViewMP example.
  };

in
{
  # --- Add Simplenote to your system packages ---
  home.packages = with pkgs; [
    simplenote # This adds the package only to the user's environment
  ];
}
