{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.blazing-fan-daemon;

  package = self.packages.${pkgs.stdenv.hostPlatform.system}.blazing-fan-daemon;

  dbusPolicy = pkgs.writeTextDir "share/dbus-1/system.d/dev.thatwhichis.daemon.conf" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE busconfig PUBLIC
      "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
      "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">

    <busconfig>
      <!-- The systemd service currently runs as root. -->
      <policy user="root">
        <allow own="dev.thatwhichis.daemon"/>
      </policy>

      <!-- Allow local clients, such as the TUI, to call the daemon. -->
      <policy context="default">
        <allow send_destination="dev.thatwhichis.daemon"/>
      </policy>
    </busconfig>
  '';
in
{
  options.services.blazing-fan-daemon.enable = lib.mkEnableOption "the blazing-fan daemon";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];

    services.dbus.packages = [ dbusPolicy ];

    systemd.services.blazing-fan-daemon = {
      description = "Compute Blade Smart Fan daemon";

      wantedBy = [ "multi-user.target" ];

      after = [ "dbus.service" ];
      requires = [ "dbus.service" ];

      environment = {
        # ProjectDirs will resolve the configuration as:
        # /etc/blazing-fan-daemon/config.toml
        XDG_CONFIG_HOME = "/etc";

        RUST_LOG = "info";
      };

      serviceConfig = {
        Type = "notify";
        NotifyAccess = "main";

        ExecStart = lib.getExe package;

        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
