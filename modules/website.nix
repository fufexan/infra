{
  services.nginx.virtualHosts."fufexan.net" = {
    root = "/var/www/fufexan.net";
    forceSSL = true;
    enableACME = true;
  };

  systemd.services.nginx.serviceConfig.ReadWritePaths = ["/var/www"];
}
