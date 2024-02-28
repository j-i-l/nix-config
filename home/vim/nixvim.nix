{ pkgs, lib, config, ... }:
{
  # inputs.nixvim.homeManagerModules.nixvim = {
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
  };
}
