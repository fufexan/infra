{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    # ./minecraft.nix
  ];

  age.secrets.aiostreams-env = {
    file = "${self}/secrets/aiostreams-env.age";
    owner = "root";
    mode = "400";
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.tailscale.extraSetFlags = [
    "--advertise-exit-node"
  ];

  services.aiostreams = {
    enable = true;
    environment =
      let
        fqdn = "aiostreams.${config.networking.domain}";
      in
      {
        ADDON_ID = fqdn;
        BASE_URL = "https://${fqdn}";
      };
    environmentFiles = [
      config.age.secrets.aiostreams-env.path
    ];
  };

  systemd.services.tailscale-transport-layer-offloads = {
    # Borrowed from https://github.com/kivikakk/vyxos/blob/a5d208520c22c9d7a2ff504d33d8b5ccb9b991d3/modules/net/default.nix#L93
    # See https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration.
    description = "Tailscale: better performance for exit nodes";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/sbin/ethtool -K enp1s0 rx-udp-gro-forwarding on rx-gro-list off";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.network.networks."30-wan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = "ipv4";
      Address = "2a01:4f8:c013:eb9::1/64";
      Gateway = "fe80::1";
    };
  };

  systemd.network.networks."90-ethernet".enable = false;

  networking.hostName = "germanium";

  system.stateVersion = "24.05";
}
