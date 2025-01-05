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
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager/release-24.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
        url = "github:nix-community/nixvim/nixos-24.11";
        # url = "github:nix-community/nixvim/nixos-unstable";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # # note: target a specific tag like this:
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, ... }: 
  let
    userInfo = import ./userInfo.nix; 
    deviceInfo = import ./deviceInfo.nix; 
    specialArgs =
      inputs
      // {
        inherit userInfo deviceInfo;
      };
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
  in {
    nixosConfigurations = {
      nano = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          # nixvim.nixosModules.nixvim
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = overlays;
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
