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

  users.users.${userInfo.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "lxd" "video"]; # Enable ‘sudo’ for the user.
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

  # enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  sound.enable = true;
  # sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;

  # enable backlight control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
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
