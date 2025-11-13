{ config, lib, pkgs, ... }:

{	

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };
  
  i18n.inputMethod = {
  	enable = true;
  	type = "fcitx5";
  	fcitx5.addons = with pkgs; [
  	   fcitx5-gtk
  	   fcitx5-bamboo
  	];
  };
}