{ config, lib, pkgs, ... }:

{	
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true; 
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
  '';
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}