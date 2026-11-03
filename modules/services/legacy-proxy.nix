{
  self,
  config,
  pkgs,
  ...
}:
let
  inherit (config.networking) domain;
  fqdn = "jmap.${domain}";
  port = 8080;

  # Zoho has no JMAP, ManageSieve or usable CardDAV, so only IMAP and SMTP are wired.
  # Custom-domain (paid) accounts use the *pro hosts on the EU datacenter.
  providers = pkgs.writeText "legacy-proxy-providers.json" (
    builtins.toJSON {
      zoho = {
        imap = {
          host = "imappro.zoho.eu";
          port = 993;
          secure = true;
        };
        smtp = {
          host = "smtppro.zoho.eu";
          port = 587;
          starttls = true;
        };
        sieve = null;
        carddav = null;
        auth.mech = [
          "PLAIN"
          "LOGIN"
        ];
      };
    }
  );
in
{
  # VAULT_KEY and SESSION_HMAC_KEY, each `openssl rand -base64 32`
  age.secrets.legacy-proxy-env = {
    file = "${self}/secrets/legacy-proxy-env.age";
    mode = "400";
  };

  systemd.services.legacy-proxy = {
    description = "JMAP gateway for IMAP/SMTP mail servers";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    environment = {
      PORT = toString port;
      LISTEN_HOST = "127.0.0.1";
      PUBLIC_URL = "https://${fqdn}";
      DATA_DIR = "/var/lib/legacy-proxy";
      PROVIDERS_FILE = providers;
      DEFAULT_PROVIDER = "zoho";
    };

    serviceConfig = {
      ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.legacy-proxy}/bin/legacy-proxy";
      EnvironmentFile = config.age.secrets.legacy-proxy-env.path;
      DynamicUser = true;
      StateDirectory = "legacy-proxy";
      Restart = "on-failure";

      # hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      LockPersonality = true;
      SystemCallArchitectures = "native";
    };
  };

  services.caddy.virtualHosts.${fqdn}.extraConfig = ''
    encode zstd gzip
    reverse_proxy 127.0.0.1:${toString port}
  '';
}
