{ pkgs, lib, ...}:

{
  # globally enable flakes
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      # Optimize storage
      # You can also manually optimize the store via:
      #    nix-store --optimise
      # Refer to the following link for more details:
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      download-buffer-size = 1000000000; # 1 GB 
    };
  };
  
  # globally as default allow unfree packages
  # nixpkgs.config.allowUnfree = lib.mkDefault true;

  hardware.enableAllFirmware = lib.mkDefault true;

  # storage optimization:
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  # boot.loader.grub.configurationLimit = 10;

  # globally installed packages
  environment.systemPackages = with pkgs; [
    qt6.qtwayland  # for qt applications
    ncdu # to check directory sizes
    vim
    wget
    mkpasswd
    pass
    sshuttle
    pinentry-curses
    gnupg
    git
  ];
  # enable printer
  services.printing.enable = true;
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  };

  # using udisksctl to mount devices
  services.udisks2.enable = true;
  # config to make gpg work
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = lib.mkDefault "25.05"; # Did you read the comment?

  #----=[ Fonts ]=----#
  # install some fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu_font_family
      font-awesome
      fira-mono
      hasklig
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

}
