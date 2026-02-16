{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # ./minecraft.nix
  ];

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
