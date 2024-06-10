{ pkgs, lib, ...}:

{
  # globally enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  
  # globally as default allow unfree packages
  # nixpkgs.config.allowUnfree = lib.mkDefault true;

  hardware.enableAllFirmware = lib.mkDefault true;

  # storage optimization:
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  # boot.loader.grub.configurationLimit = 10;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # globally installed packages
  environment.systemPackages = with pkgs; [
    ncdu # to check directory sizes
    vim
    wget
    mkpasswd
    pass
    pinentry-curses
    gnupg
    git
  ];
  # using udisksctl to mount devices
  services.udisks2.enable = true;
  # config to make gpg work
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = lib.mkDefault "24.05"; # Did you read the comment?

  #----=[ Fonts ]=----#
  # install some fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu_font_family
      nerdfonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Hasklig" "Ubuntu"];
        sansSerif = ["FiraMono" "Ubuntu"];
        monospace = ["Ubuntu"];
      };
    };
  };

}
