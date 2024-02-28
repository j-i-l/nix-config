{
  description = "j-i-l's flake";

  # add the comunity cache
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
        url = "github:nix-community/nixvim/nixos-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # # note: target a specific tag like this:
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, ... }: 
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
      nano = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          # nixvim.nixosModules.nixvim
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${userInfo.username}.imports = [
              ./home
              inputs.nixvim.homeManagerModules.nixvim
            ];
            # home-manager.users.${userInfo.username} = import ./home;
          }
          ./hosts/nano
        ];
      };
    };
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
