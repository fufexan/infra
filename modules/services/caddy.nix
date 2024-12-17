{
  self,
  pkgs,
  ...
}: {
  networking.firewall = let
    ports = [80 443];
  in {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };

  services.caddy = {
    enable = true;
    package = self.packages.${pkgs.system}.caddy-with-plugins;
  };
}
