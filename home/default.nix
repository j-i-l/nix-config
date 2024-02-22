{ config, pkgs, lib, userInfo, ... }:

{
  imports = [
    ./shell
    ./hyprland
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
      # file browser
      xfce.thunar
      # browsers
      firefox-wayland 
      # chat
      telegram-desktop

      (pkgs.nerdfonts.override { fonts = ["FiraMono" "DroidSansMono" "Hasklig" ]; })
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

      # neofetch
      # nnn # terminal file manager

      # # archives
      # zip
      # xz
      # unzip
      # p7zip

      # # utils
      # ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      # yq-go # yaml processer https://github.com/mikefarah/yq
      # eza # A modern replacement for ‘ls’
      # fzf # A command-line fuzzy finder

      # # networking tools
      # mtr # A network diagnostic tool
      # iperf3
      # dnsutils  # `dig` + `nslookup`
      # ldns # replacement of `dig`, it provide the command `drill`
      # aria2 # A lightweight multi-protocol & multi-source command-line download utility
      # socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      # ipcalc  # it is a calculator for the IPv4/v6 addresses

      # # misc
      # cowsay
      # file
      which
      # tree
      # gnused
      # gnutar
      # gawk
      # zstd
      gnupg

      # # nix related
      # #
      # # it provides the command `nom` works just like `nix`
      # # with more details log output
      # nix-output-monitor

      # # productivity
      # glow # markdown previewer in terminal

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

  wayland.windowManager.hyprland.enable = true;
}
