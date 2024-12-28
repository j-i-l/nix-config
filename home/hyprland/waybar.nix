{ config, lib, pkgs, ... }:

let
  # Dependencies
  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils}/bin/cut";
  find = "${pkgs.findutils}/bin/find";
  grep = "${pkgs.gnugrep}/bin/grep";
  pgrep = "${pkgs.procps}/bin/pgrep";
  tail = "${pkgs.coreutils}/bin/tail";
  wc = "${pkgs.coreutils}/bin/wc";
  xargs = "${pkgs.findutils}/bin/xargs";
  timeout = "${pkgs.coreutils}/bin/timeout";
  ping = "${pkgs.iputils}/bin/ping";

  jq = "${pkgs.jq}/bin/jq";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  wofi = "${pkgs.wofi}/bin/wofi";

  # Function to simplify making waybar outputs
  jsonOutput = name: { pre ? "", text ? "", tooltip ? "", alt ? "", class ? "", percentage ? "" }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
    set -euo pipefail
    ${pre}
    ${jq} -cn \
      --arg text "${text}" \
      --arg tooltip "${tooltip}" \
      --arg alt "${alt}" \
      --arg class "${class}" \
      --arg percentage "${percentage}" \
      '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
  ''}/bin/waybar-${name}";

  hasSway = config.wayland.windowManager.sway.enable;
  sway = config.wayland.windowManager.sway.package;
  hasHyprland = config.wayland.windowManager.hyprland.enable;
  hyprland = config.wayland.windowManager.hyprland.package;
in
{
  # Let it try to start a few more times
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        # mode = "dock";
        layer = "top";
        height = 7;
        margin = "0";
        position = "top";
        modules-left = [
          "custom/menu"
          "hyprland/workspaces"
          "custom/currentplayer"
          "custom/player"
        ];

        modules-center = [
          "cpu"
          # "custom/gpu"
          "memory"
          "clock"
          "pulseaudio"
          "battery"
        ];

        modules-right = [
          "custom/kbLayout"
          "network"
          "tray"
          "custom/hostname"
        ];

        clock = {
          interval = 1;
           format = "  {:%Y/%m/%d    %H:%M:%S}";
          format-alt = " {:%a %b %d, %G}";
          # format = "{:%d/%m %H:%M:%S}";
          # format-alt = "{:%Y-%m-%d %H:%M:%S %z}";
          on-click-left = "mode";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          # tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "  {usage}%";
        };
        memory = {
          format = "  {}%";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [ "" "" "" ];
          };
          on-click = pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };
        "custom/menu" = let
          isFullScreen =
            "${hyprland}/bin/hyprctl activewindow -j | ${jq} -e '.fullscreen' &>/dev/null";
        in {
          interval = 1;
          return-type = "json";
          exec = jsonOutput "menu" {
            text = "";
            tooltip = ''$(${cat} /etc/os-release | ${grep} PRETTY_NAME | ${cut} -d '"' -f2)'';
            class = "$(if ${isFullScreen}; then echo fullscreen; fi)";
          };
          on-click-left = "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%";
          on-click-right = "${hyprland}/bin/hyprctl dispatch togglespecialworkspace";
        };
        "custom/kbLayout" = 
        { 
          interval = 1;
          return-type = "json";
          exec = jsonOutput "kbLayout" {
            pre = ''
              kbLayout="$(${hyprland}/bin/hyprctl devices -j | ${jq} -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap' | ${cut} -c 1-2)"
            '';
            text = "  $kbLayout";
          };
          # exec = "hyprctl devices -j | jq -r '.keyboards[] | select(.name == \\\"at-translated-set-2-keyboard\\\") | .active_keymap' | cut -c 1-2 | tr 'A-Z' 'a-z'}";
          tooltip = "Current layout";
        };
        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
          on-click = "${systemctl} --user restart waybar";
        };
        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''
              player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
              count="$(${playerctl} -l 2>/dev/null | ${wc} -l)"
              if ((count > 1)); then
                more=" +$((count - 1))"
              else
                more=""
              fi
            '';
            alt = "$player";
            tooltip = "$player ($count available)";
            text = "$more";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "Celluloid" = "󰎁 ";
            "spotify" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "qutebrowser" = "󰖟 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
            "chromium" = " ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };
        "custom/player" = {
          exec-if = "${playerctl} status 2>/dev/null";
          exec = ''${playerctl} metadata --format '{"text": "{{title}} - {{artist}}", "alt": "{{status}}", "tooltip": "{{title}} - {{artist}} ({{album}})"}' 2>/dev/null '';
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
        };
      };

    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    # style = let inherit (config.colorscheme) colors; in /* css */ ''
    style = /* css */ ''
      * {
        font-size: 12pt;
        padding: 0;
        margin: 0 0.4em;
      }

      window#waybar {
        padding: 0;
        opacity: 0.75;
        border-radius: 0.5em;
      }
      .modules-left {
        margin-left: -0.65em;
      }
      .modules-right {
        margin-right: -0.65em;
      }

      #workspaces button {
        padding-left: 0.4em;
        padding-right: 0.4em;
        margin-top: 0.15em;
        margin-bottom: 0.15em;
      }
      #workspaces button.hidden {
      }
      #workspaces button.focused {
        background-color: #007acc; 
      }
      #workspaces button.active {
        background-color: blue; 
      }

      #clock {
        padding-right: 1em;
        padding-left: 1em;
        border-radius: 0.5em;
      }

      #custom-menu {
        padding-right: 1.5em;
        padding-left: 1em;
        margin-right: 0;
        border-radius: 0.5em;
      }
      #custom-menu.fullscreen {
      }
      #custom-hostname {
        padding-right: 1em;
        padding-left: 1em;
        margin-left: 0;
        border-radius: 0.5em;
      }
      #custom-currentplayer {
        padding-right: 0;
      }
      #custom-kbLlayout {
        padding-right: 1.5em;
        padding-left: 1em;
        margin-right: 0;
        border-radius: 0.5em;
      }
      #tray {
      }
      #cpu, #memory {
        margin-left: 0.05em;
        margin-right: 0.55em;
      }
    '';
  };
}
