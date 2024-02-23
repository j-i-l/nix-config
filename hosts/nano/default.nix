{ config, inputs, lib, pkgs, userInfo, deviceInfo, ... }: {
  imports = [

    ../../modules/core.nix
    ./hardware-configuration.nix

  ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "nano";
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    useDHCP = lib.mkDefault true;
  };

  users.users.${userInfo.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "${userInfo.pwhash}";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/${deviceInfo.disk_uuid}";
        preLVM = true;
      };
    };

  };

  system.stateVersion = "23.11";

  hardware.opengl.enable = lib.mkDefault true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;

  # # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
  # services.power-profiles-daemon = {
  #   enable = true;
  # };
  # security.polkit.enable = true;

  # rtkit is optional but recommended
  # hardware.pulseaudio.enable = false;
  # sound.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa = {
  #     enable = true;
  #     support32Bit = true;
  #   };
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;
  # };

}
