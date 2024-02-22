{
  impermanence,
  pkgs,
  ...
}: {

  environment = {
    # Declare what we want to keep
    # --Homes--
    persistence."/home" = {
      directories = [
        "/jonas"
      ];
    };
    # --Persist--
    persistence."/persist" = {
      directories = [
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
    # --Logs--
    persistence."/var/log" = {
      directories = [
        "/var/log"
      ];
    };
  };

}
