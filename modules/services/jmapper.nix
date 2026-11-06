{
  inputs,
  self,
  config,
  ...
}:
let
  inherit (config.networking) domain;
  fqdn = "jmap.${domain}";
  port = 8765;
in
{
  imports = [ inputs.jmapper.nixosModules.default ];

  # accounts file, see https://github.com/amaanq/jmapper#config. Bulwark logs in with the
  # account email and its bearer_token (`openssl rand -hex 32`):
  age.secrets.jmapper-accounts = {
    file = "${self}/secrets/jmapper-accounts.age";
    owner = config.services.jmapper.user;
    mode = "400";
  };

  services.jmapper = {
    enable = true;
    accountsFile = config.age.secrets.jmapper-accounts.path;
    settings.server = {
      bind = "127.0.0.1:${toString port}";
      session_url = "https://${fqdn}";
      cors_origins = [ "https://mail.${domain}" ];
    };
  };

  services.caddy.virtualHosts.${fqdn}.extraConfig = ''
    encode zstd gzip
    reverse_proxy 127.0.0.1:${toString port}
  '';
}
