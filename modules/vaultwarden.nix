{
  config,
  self,
  ...
}: let
  inherit (config.networking) domain;
  cfg = config.services.vaultwarden.config;
in {
  age.secrets.vaultwarden-env = {
    file = "${self}/secrets/vaultwarden-env.age";
    owner = "vaultwarden";
    mode = "400";
  };

  # this forces the system to create backup folder
  systemd.services.backup-vaultwarden.serviceConfig = {
    User = "root";
    Group = "root";
  };

  services.caddy.virtualHosts."vault.fufexan.net".extraConfig = ''
    reverse_proxy * ${cfg.ROCKET_ADDRESS}:${toString cfg.ROCKET_PORT}
  '';

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;

    backupDir = "/var/lib/vaultwarden/backup";

    config = {
      DOMAIN = "https://vault.${domain}";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;

      extendedLogging = true;
      invitationsAllowed = false;
      showPasswordHint = false;

      useSyslog = true;
      logLevel = "warn";

      signupsAllowed = false;
      signupsDomainsWhitelist = domain;
      signupsVerify = true;

      smtpAuthMechanism = "Login";
      smtpFrom = "vaultwarden@${domain}";
      smtpFromName = "fufexan's Vaultwarden Service";
      smtpHost = "smtp.zeptomail.eu";
      smtpPort = 465;
      smtpSecurity = "force_tls";
      dataDir = "/var/lib/vaultwarden";
    };
  };
}
