{
  inputs,
  self,
  config,
  pkgs,
  ...
}:
let
  inherit (config.networking) domain;
  fqdn = "mail.${domain}";
  sessionSecret = "/run/credentials/bulwark.service/session-secret";
in
{
  # module and package come from NixOS/nixpkgs#574920, drop this once it merges
  disabledModules = [ "services/web-apps/bulwark.nix" ];
  imports = [ "${inputs.nixpkgs-bulwark}/nixos/modules/services/web-apps/bulwark.nix" ];

  services.bulwark = {
    enable = true;
    package = inputs.nixpkgs-bulwark.legacyPackages.${pkgs.stdenv.hostPlatform.system}.bulwark;
    hostname = "127.0.0.1";
    port = 3000;

    settings = {
      appName = "Mail";
      # legacy-proxy, see legacy-proxy.nix
      jmapServerUrl = "https://jmap.${domain}";
      # legacy-proxy is not Stalwart
      stalwartFeaturesEnabled = false;

      # "remember me" sessions and server-side settings sync
      sessionSecretFile = sessionSecret;
      settingsSyncEnabled = true;
    };
  };

  # the service is a DynamicUser, which cannot read the root-owned agenix file,
  # so systemd copies it to /run/credentials/bulwark.service/session-secret
  age.secrets.bulwark-session-secret.file = "${self}/secrets/bulwark-session-secret.age";

  systemd.services.bulwark = {
    # Caddy terminates TLS, so cookies and HSTS must be marked secure explicitly
    # (see the X-Forwarded-Proto note below)
    environment.COOKIE_SECURE = "true";
    serviceConfig.LoadCredential = "session-secret:${config.age.secrets.bulwark-session-secret.path}";
  };

  services.caddy.virtualHosts.${fqdn}.extraConfig = ''
    encode zstd gzip
    reverse_proxy 127.0.0.1:${toString config.services.bulwark.port} {
      # with X-Forwarded-Proto: https, next fetches https://localhost:3000 for its
      # own redirects over plain http and answers 500 (EPROTO)
      header_up -X-Forwarded-Proto
    }
  '';
}
