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
in
{
  options.services.blazing-fan-daemon.enable = lib.mkEnableOption "the blazing-fan daemon";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];

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

        ExecStart = lib.getExe package;

        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
