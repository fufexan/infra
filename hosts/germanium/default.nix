{
  imports = [
    ./hardware-configuration.nix
    # ./minecraft.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  systemd.network = {
    networks.ethernet.extraConfig = ''
      [Match]
      Type = ether
      [Network]
      Address = 2a01:4f8:c013:eb9::1/64
      DHCP = ipv4
      IPv6AcceptRA = no
      LinkLocalAddressing = no
    '';
  };

  networking.hostName = "germanium";

  system.stateVersion = "24.05";
}
