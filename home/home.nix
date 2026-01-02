{ pkgs, inputs, username, claude-code-nix, pkgs-unstable, opencode, snitch, ... }:

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


  home.file= {
    ".config/yazi/yazi.toml" = {
      source = ../config/yazi.toml;
    };
    ".config/bash/bashrc_extra" = {
      source = ../config/bashrc_extra;
    };
    ".config/tmux/tmux.conf" = {
      source = ../config/tmux.conf;
    };
    ".config/helix/config.toml" = {
      source = ../config/helix.toml;
    };
    ".config/helix/yazi-picker.sh" = {
      source = ../config/yazi-picker.sh;
    };
  };



  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    fastfetch
    nodejs_22
    yarn
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
    opencode.packages.${pkgs.system}.default
    snitch.packages.${pkgs.system}.default
    pkgs-unstable.uv
    jq
    tiny-rdm
    gh
    openssl
    btop
    yazi
    pkgs-unstable.gemini-cli
    ngrok
    tmux
    helix
    rsync
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Long Vu";
    userEmail = "hlongvu@gmail.com";
    extraConfig = {
      safe.directory = [
        "*"
        # Add other safe directories as needed
      ];
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    # npm config set prefix '~/.npm-global'
    bashrcExtra = ''
      if [ -f ~/.config/bash/bashrc_extra ]; then
          . ~/.config/bash/bashrc_extra
      fi
      if [ -f ~/.config/bash/bashrc_manual ]; then
          . ~/.config/bash/bashrc_manual
      fi
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
