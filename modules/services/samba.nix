{
  networking.firewall = {
    allowedTCPPorts = [
      139
      445
      5357
    ];
    allowedUDPPorts = [
      137
      138
      3702
    ];
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
          # R/W
          "read only" = "no";
          # For authenticated users only
          "guest ok" = "no";
          # Only users in the `users` group
          # Make sure you add each user to samba's DB using `sudo smbpasswd -a <user>`
          # Also enable them using `sudo smbpasswd -e <user>`
          "valid users" = "@users";
          "force group" = "users";
          # Make sure the entire /media is 775, or you'll have problems with the lines below
          "create mask" = "0775";
          "directory mask" = "0775";
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
