# home server configuration
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking.hostName = "homesv";

  # don't suspend when lid is closed
  services.logind.lidSwitch = "ignore";
}
