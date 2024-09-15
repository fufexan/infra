{
  imports = [
    ./hardware.nix
    ./impermanence.nix
    # ./minecraft.nix
  ];

  networking.hostName = "germanium";

  services.getty.autologinUser = "root";
}
