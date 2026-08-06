{
  self,
  config,
  ...
}:
{
  age.secrets.mihai-password = {
    file = "${self}/secrets/mihai-password.age";
    owner = "root";
    mode = "400";
  };

  users.users.mihai = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      ./keys/mihai-io.pub
      ./keys/mihai-ganymede.pub
    ];
    hashedPasswordFile = config.age.secrets.mihai-password.path;
  };
}
