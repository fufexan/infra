{ config, ... }:
let
  inherit (config.networking) domain;
  # toshiba's tailscale address, immich listens on 2283
  upstream = "100.114.181.56:2283";
in
{
  services.caddy.virtualHosts."immich.${domain}".extraConfig = ''
    encode zstd gzip
    reverse_proxy ${upstream}
  '';
}
