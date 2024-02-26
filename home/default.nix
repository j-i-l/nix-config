{ config, pkgs, lib, userInfo, ... }:

{
  imports = [
    ./shell
    ./neovim
    ./hyprland
    ./wofi
  ];
  home = {
    username = "${userInfo.username}";
    homeDirectory = lib.mkDefault "/home/${userInfo.fullname}";

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      # filemanager
      ranger
      xfce.thunar
      # browsers
      firefox-wayland 
      # for firefox we need the icons from gtk and for this we need dconf
      pkgs.dconf
      # chat
      telegram-desktop

      # This is how we get some fonts
      (pkgs.nerdfonts.override { fonts = ["FiraMono" "DroidSansMono" "Hasklig" ]; })
      # here are some handy command line tools

      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      jq # A lightweight and flexible command-line JSON processor
      fzf # A command-line fuzzy finder
      bat # a `cat` clone with syntax highlighting + git integration
      # ripgrep # recursively searches directories for a regex pattern
      # yq-go # yaml processer https://github.com/mikefarah/yq
      # eza # A modern replacement for ‘ls’

      # networking tools
      nmap # A utility for network discovery and security auditing
      # mtr # A network diagnostic tool
      # iperf3
      # dnsutils  # `dig` + `nslookup`
      # ldns # replacement of `dig`, it provide the command `drill`
      # aria2 # A lightweight multi-protocol & multi-source command-line download utility
      # socat # replacement of openbsd-netcat
      # ipcalc  # it is a calculator for the IPv4/v6 addresses

      # misc
      which
      gnupg
      # cowsay
      # file
      # tree
      # gnused
      # gnutar
      # gawk
      # zstd

      # productivity
      glow # markdown previewer in terminal

      btop  # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ];
  };

  # fix some icon issues with firefox
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  
  # install some fonts
  fonts.fontconfig.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # basic configuration of git
  programs.git = {
    enable = true;
    userName = "${userInfo.fullname}";
    userEmail = "${userInfo.email}";
  };

  # # starship - an customizable prompt for any shell
  # programs.starship = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     add_newline = false;
  #     aws.disabled = true;
  #     gcloud.disabled = true;
  #     line_break.disabled = true;
  #   };
  # };
  # Let home Manager install and manage itself.

  programs.home-manager.enable = true;

  # Enable the usage of hyprland
  wayland.windowManager.hyprland.enable = true;
}
