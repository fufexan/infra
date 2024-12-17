{config, ...}: {
  security.acme.certs.soju = {};

  services.soju = let
    certDir = config.security.acme.certs.soju.directory;
  in {
    enable = true;

    tlsCertificate = "${certDir}/fullchain.pem";
    tlsCertificateKey = "${certDir}/key.pem";
  };
}
