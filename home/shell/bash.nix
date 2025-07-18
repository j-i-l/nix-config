{userInfo, pkgs, ...}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      set -o vi
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      export HISTFILESIZE=
      export HISTSIZE=
      export HISTTIMEFORMAT="[%F %T] "
    '';
    # historyFileSize = 0;  # to keep
    # historySize = 0;  # to load
    historyControl = [ "ignoredups" "erasedups" ];
    shellOptions = [ "histappend" ];
    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "${pkgs.kubectl}/bin/kubectl";
      # commands are broken:
      urldecode = "${pkgs.python3}/bin/python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "${pkgs.python3}/bin/python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };
}
