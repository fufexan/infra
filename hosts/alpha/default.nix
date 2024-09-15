{
  imports = [
    ./hardware.nix
    ./impermanence.nix
    # ./minecraft.nix
  ];

  networking.hostName = "alpha";

  services.getty.autologinUser = "root";
}
