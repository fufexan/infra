{
  networking.firewall = {
    allowedTCPPorts = [139 445 5357];
    allowedUDPPorts = [137 138 3702];
  };

  services = {
    samba = {
      enable = true;
      nsswins = true;
      settings = {
        global = {
          "hosts allow" = "10.0.0.0/8 100.0.0.0/8 localhost";
          "hosts deny" = "0.0.0.0/8";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };

        drive = {
          path = "/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0777";
          "directory mask" = "0777";
        };
      };
      openFirewall = true;
    };

    samba-wsdd = {
      enable = true;
      discovery = true;
    };
  };
}
