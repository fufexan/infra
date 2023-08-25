{
  imports = [
    ./hardware.nix
    ./impermanence.nix
  ];

  networking.hostName = "alpha";

  services.getty.autologinUser = "root";
}
