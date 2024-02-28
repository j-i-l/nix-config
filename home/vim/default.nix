{ inputs, config, pkgs, lib, userInfo, ... }:
{
   imports = [
     # ./nixvim.nix
     ./neovim.nix
   ];
}
