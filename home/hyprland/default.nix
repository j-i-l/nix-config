{pkgs, config, ...}: let 
    colors = import ./mocha.nix; 
in {

  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    wofi
  ];
  wayland.windowManager.hyprland = {
    settings = {
        # --Keybindings--
        "$mod" = "SUPER";

        # --Mappings--
        "$term" = "alacritty";
        "$browser" = "firefox";
        "$files" = "thunar";

        input = {
          kb_options = "caps:swapescape";
        };
        general = {
          gaps_in = 3;
          gaps_out = 5;
          border_size = 1;
          "col.active_border" = "rgb(${colors.blueAlpha}) rgb(${colors.skyAlpha}) 45deg";
          "col.inactive_border" = "rgb(${colors.baseAlpha})";
          resize_on_border = "yes";
          extend_border_grab_area = 15;
          layout = "dwindle";
        };
        bind =
          [
            # --Hyprland--
            "$mod SHIFT, Q, killactive,"
            "$mod, F, fullscreen,"
	    "$mod, P, pseudo,"

            # --Focus--
            "$mod, L, movefocus, r"
            "$mod, H, movefocus, l"
            "$mod, J, movefocus, d"
	    "$mod, K, movefocus, u" 
            "$mod, S, togglespecialworkspace,"

            # --Move--
            "$mod SHIFT, L, movewindow, r"
            "$mod SHIFT, H, movewindow, l"
            "$mod SHIFT, J, movewindow, d"
	    "$mod SHIFT, K, movewindow, u" 
	    "$mod SHIFT, S, movetoworkspace, special"

            # --Mappings--
            "$mod, B, exec, $browser"
            "$mod, Return, exec, $term"
            # "$mod SHIFT, Return, exec, wofi --show run --xoffset=1670 --yoffset=12 --width=230px --height=984 --style=$HOME/.config/wofi.css --term=footclient --prompt=Run"
            "$mod SHIFT, Return, exec, wofi --show run --style=$HOME/.config/wofi.css --term=footclient --prompt=Run --normal-window"
            ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );
    };
  };
}
