{ pkgs, lib, config, ... }:
{
  # inputs.nixvim.homeModules.nixvim = {
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
  };
}
