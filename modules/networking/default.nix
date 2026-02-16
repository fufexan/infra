{ lib, ... }:
{
  imports = [
    ./tailscale.nix
    ./openssh.nix
  ];

  systemd.network = {
    enable = true;
    networks."90-ethernet" = lib.mkDefault {
      matchConfig.Name = "ether";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = "yes";
      };
    };
  };
}
