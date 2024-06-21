{ config, inputs, lib, pkgs, userInfo, deviceInfo, ... }: 
let
  obsidian = pkgs.callPackage ../packages/obsidian.nix {};
in {

  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
