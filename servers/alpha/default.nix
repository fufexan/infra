{
  imports = [
    ./hardware.nix
    ./impermanence.nix
  ];

  networking.hostName = "alpha";

  system.stateVersion = "23.11";
  systemd.network = {
    enable = true;
    networks.ethernet.extraConfig = ''
      [Match]
      Type = ether
      [Network]
      DHCP = both
      IPv6AcceptRA = true
      # Usually dhcpv6 should give us a public address, but it doesn't seem to work for oracle with both networkd/dhcpcd
      # so we set it manually here. One can get the address by clicking on the primary vnic in the oracle console and
      # under Resources -> IPv6 Addresses
      # Address = #
    '';
  };
}
