{ config, inputs, lib, pkgs, userInfo, deviceInfo, ... }: 
{
  imports = [
    ./hardware-configuration.nix
    # here we import the modules we want to use
    ../../modules/core.nix
    ../../modules/nix-ld.nix
    ../../modules/pulse-vpn.nix
    # ../../modules/obsidian.nix

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
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

  programs.virt-manager.enable = true;
  
  # TODO: temporal workaround: see https://github.com/NixOS/nixpkgs/issues/422385
  virtualisation.lxd.enable = false;
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
    extraGroups = [ "wheel" "audio" "lxd" "video" "docker" "libvirtd"];
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

  system.stateVersion = "25.05";

  # increase space of /run/users/
  services.logind.extraConfig = "RuntimeDirectorySize=8G";

  # tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  # TODO: This should be tested, not sure if needed
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # file syncing
  services.syncthing = {
    enable = true;
    user = "${userInfo.username}";
    dataDir = "/home/${userInfo.username}";  # default location for new folders
    configDir = "/home/${userInfo.username}/.config/syncthing";
    openDefaultPorts = true;
    settings.gui = {
      # user = "myuser";
      # password = "mypassword";
    };
    settings = {
      devices = {
        # "zephyrus" = { id = "DEVICE-ID-GOES-HERE"; };
        #   "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      };
      folders = {
        # "Documents" = {
        #   path = "/home/myusername/Documents";
        #   devices = [ "device1" "device2" ];
        # };
        # "Example" = {
        #   path = "/home/myusername/Example";
        #   devices = [ "device1" ];
        #   # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
        #   ignorePerms = false;
        # };
      };
    };
    # key = "${</path/to/key.pem>}";
    # cert = "${</path/to/cert.pem>}";
    # Note: To generate keys run:
    # nix-shell -p syncthing --run "syncthing -generate=myconfig"
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder


  hardware.graphics.enable = lib.mkDefault true;

  # enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # sound.enable = false;
  # sound.mediaKeys.enable = false;
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
