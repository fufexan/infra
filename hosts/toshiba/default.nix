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

  networking.hostName = "toshiba";

  # don't suspend when lid is closed
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  users.users.user = {
    isNormalUser = true;
    createHome = false;
    hashedPassword = "$y$j9T$Ne9tVneuIjJslba3ErU0Z.$peEWu/MZQ1sZwkqY2vMK8eGDBCJqJt2T0uvmqLKnDP0";
  };

  system.stateVersion = "26.05";
}
