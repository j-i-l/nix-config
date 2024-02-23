{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.wofi;
in {
  options.modules.wofi = {
    enable = lib.mkEnableOption "wofi";
  };
  config = lib.mkIf cfg.enable {
    home.file.".config/wofi.css".source = ./wofi.css;
  };
}
