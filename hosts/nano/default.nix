{ config, inputs, lib, pkgs, userInfo, deviceInfo, ... }: {
  imports = [

    ../../modules/core.nix
    ./hardware-configuration.nix

  ];

  # for tracking keystrokes:
  # sudo libinput debug-events --show-keycodes 

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "nano";
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    useDHCP = lib.mkDefault true;
  };

  # enable virtualisation
  virtualisation.lxd.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # to change the storage location
    # daemon.settings = {
    #   data-root = "/some-place/to-store-the-docker-data";
    # };
  };

  users.users.${userInfo.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "lxd" "video" "docker"];
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

  # increase space of /run/users/
  services.logind.extraConfig = "RuntimeDirectorySize=8G";

  hardware.opengl.enable = lib.mkDefault true;

  # enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  sound.enable = false;
  sound.mediaKeys.enable = false;
  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  #   extraModules = [ pkgs.pulseaudio-ctl ];
  # };
  # services.pipewire.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };


  # enable backlight control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SINK@ toggle"; }
      { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/wpctl set-volume @DEFAULT_SINK@ 5%-"; }
      { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/wpctl set-volume @DEFAULT_SINK@ 5%+"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

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
