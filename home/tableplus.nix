# https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage
 { config, pkgs, ... }:

let
  sha = "sha256-nbVwHaN+T6USX7GmaEABqFP259+ds4Meq3onLTv9lJw=";
  pname = "tableplus"; # Required by appimageTools.extract
  version = "64";
  linkAppImageURL = "https://tableplus.com/release/linux/x${version}/TablePlus-x${version}.AppImage";

  src = pkgs.fetchurl {
      url = "${linkAppImageURL}";
      sha256 = "${sha}";
    };

  # --- Fix applied here: Added 'pname' to inherit or explicitly pass ---
  appimageContents = pkgs.appimageTools.extract {
	# You must include pname here
	inherit src version pname;
  };
  # --- Build from AppImage ---
  tableplus = pkgs.appimageTools.wrapType2 {
    inherit src pname version;
    # Add a .desktop entry for GUI launchers
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      local icon_size="512x512" # A common size for Electron AppImages
      mkdir -p $out/share/icons/hicolor/$icon_size/apps
      cp ${appimageContents}/${pname}.png $out/share/icons/hicolor/$icon_size/apps/${pname}.png
      cat > $out/share/applications/${pname}.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=TablePlus
      Icon=${pname}.png
      Exec=${pname} %F
      Categories=Office;Utility;TextEditor;
      Comment = "A database client."
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
    tableplus # This adds the package only to the user's environment
  ];
}
