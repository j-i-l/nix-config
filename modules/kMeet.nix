{ config, inputs, lib, pkgs, userInfo, deviceInfo, ... }: 
let
  kMeet = pkgs.callPackage ../packages/kMeet.nix {};
in {

  environment.systemPackages = with pkgs; [
    kMeet
  ];
}
