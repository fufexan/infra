{ config, self, ... }:
# home server configuration
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  age.secrets.toshiba-networks = {
    file = "${self}/secrets/toshiba-networks.age";
    owner = "root";
    mode = "444";
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking.hostName = "toshiba";
  networking.wireless = {
    enable = true;
    networks = {
      "[object Object]" = {
        pskRaw = "ext:psk_objectObject";
      };
    };
    secretsFile = config.age.secrets.toshiba-networks.path;
  };

  # don't suspend when lid is closed
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  users.users.user = {
    isNormalUser = true;
    createHome = false;
    hashedPassword = "$y$j9T$Ne9tVneuIjJslba3ErU0Z.$peEWu/MZQ1sZwkqY2vMK8eGDBCJqJt2T0uvmqLKnDP0";
  };

  system.stateVersion = "26.05";
}
