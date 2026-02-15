{self, ...}: {
  age.secrets.mihai-password = {
    file = "${self}/secrets/mihai-password.age";
    owner = "root";
    mode = "400";
  };

  users.users.mihai = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq9Gew1rgfdIyuriJ/Ne0B8FE1s8O/U2ajErVQLUDu9 mihai@io"
    ];
  };

  users.users.razvan = {
    isNormalUser = true;
    initialPassword = "123";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXCgRRSDBe37h5zq5Aif6KuRn6HHfpwmmsNTFZvP8vq razvan@germanium"
    ];
  };
}
