{config,pkgs, ...}:
{
  imports = [
    ./bash.nix
  ];

  # add environment variables
  home.sessionVariables = {
    # set default applications
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "kitty";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.shellAliases = {
    k = "kubectl";
  };
  # --Terminal Emulator --
  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;
    settings = {
      cursor_trail = 3;
      font_family = "Hasklug Nerd Font";
      bold_font = "auto";
      bold_italic_font = "auto";
      scrollback_lines = -1;
      shell_integration = "enabled";
      shell = "bash";
    };
  };
  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        normal = {
          family = "HasklugNerdFont";
          style = "Regular";
        };
        size = 10;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };
}
