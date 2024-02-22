{
  description = "j-i-l flake";

  # add the comunity cache
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixvim.url = "github:pta2002/nixvim";
    home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # # note: target a specific tag like this:
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
  let
    userInfo = import ./userInfo.nix; 
    deviceInfo = import ./deviceInfo.nix; 
    specialArgs =
      inputs
      // {
        inherit userInfo deviceInfo;
      };
  in {
    nixosConfigurations = {
      # my devices
      nano = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          
          # device should use home-manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${userInfo.username} = import ./home;
          }
          ./hosts/nano
          # ./users/jonas
        ];
      };
    };
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
