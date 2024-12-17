{
  networking.firewall = let
    ports = [6697];
  in {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };

  services.soju = {
    enable = true;
    hostName = "fufexan.net";
    listen = ["irc+insecure://localhost:6667"];
  };

  services.caddy.globalConfig = ''
    layer4 {
      :6697 {
        route {
          tls
          proxy {
            proxy_protocol v2
            upstream localhost:6667
          }
        }
      }
    }
  '';
}
