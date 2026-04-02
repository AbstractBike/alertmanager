{ config, lib, pkgs, ... }:
let
  cfg = config.services.prometheus.alertmanager;
in {
  # Alertmanager is packaged in nixpkgs — services.prometheus.alertmanager
  # Reference catalog: AbstractBike/machines catalog/observability/alertmanager.nix

  options.abstractbike.alertmanager = {
    enable = lib.mkEnableOption "AbstractBike Alertmanager profile";
    port = lib.mkOption {
      type = lib.types.port;
      default = 9093;
      description = "Alertmanager HTTP port";
    };
    matrixWebhookUrl = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Matrix webhook URL for alert routing";
    };
  };

  config = lib.mkIf config.abstractbike.alertmanager.enable {
    services.prometheus.alertmanager = {
      enable = true;
      port = config.abstractbike.alertmanager.port;
      configuration = {
        route = {
          receiver = "default";
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "4h";
        };
        receivers = [{
          name = "default";
          # TODO: configure receivers (Matrix, email, etc.)
        }];
      };
    };
  };
}
