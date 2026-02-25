# Stolen from https://github.com/tuxdotrs/nix-config/blob/6403fab5af751e9e0330befea0baec721b8b04e3/modules/nixos/selfhosted/containers/aiostreams.nix
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.aiostreams;
in
{
  options.services.aiostreams = {
    enable = mkEnableOption "AIOStreams";

    port = mkOption {
      type = types.int;
      default = 3000;
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/aiostreams";
      description = "Directory to store persistent AIOStreams data";
    };

    environment = mkOption {
      type = with types; attrsOf str;
      default = { };
    };

    environmentFiles = mkOption {
      type = with types; listOf path;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.aiostreams = {
      autoStart = true;
      image = "ghcr.io/viren070/aiostreams:latest";
      ports = [
        "${toString cfg.port}:3000"
      ];

      environment = cfg.environment;
      environmentFiles = cfg.environmentFiles;
      networks = [ "host" ];
      volumes = [
        "${cfg.dataDir}:/app/data"
      ];
    };

    services.caddy.virtualHosts."${cfg.environment.ADDON_ID}".extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString cfg.port} {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
