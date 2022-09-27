{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "eta";
}
