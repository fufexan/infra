{
  imports = [
    ./hardware-configuration.nix
    # ./minecraft.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking.firewall.allowedTCPPorts = [80 443];

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
