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
    j-i-l-nixvim.url = "git+https://codeberg.org/j-i-l/nixvim-config";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-25_05.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
        url = "github:nix-community/nixvim/main";
        # url = "github:nix-community/nixvim/nixos-unstable";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # # note: target a specific tag like this:
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-25_05, home-manager, nixvim, ... }: 
  let
    system = "x86_64-linux";
    deviceInfo = import ./Info/deviceInfo.nix;
    userInfo = import ./Info/userInfo.nix;
    specialArgs =
      inputs
      // {
        inherit deviceInfo userInfo inputs system;
      };
    overlays = [
       # inputs.neovim-nightly-overlay.overlays.default
    ];
  in {
    nixosConfigurations = {
      nano = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "${system}";
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
              inputs.nixvim.homeModules.nixvim
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
