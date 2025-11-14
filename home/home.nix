{ pkgs, username, claude-code-nix, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = username;
  home.homeDirectory = "/home/${username}";
  imports = [
    ./simplenote.nix
    ./tableplus.nix
    ./dashdock.nix
  ];

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    nodejs_22
    go
    gnome-tweaks
    gnumake
    # claude-code
    ghostty
    pnpm
    zoxide
    lazydocker
    lazygit
    claude-code-nix.packages."${pkgs.system}".claude-code
    
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Long Vu";
    userEmail = "hlongvu@gmail.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      alias cd=z
    '';
  };
  programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
