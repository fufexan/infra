let
  mihai-io = builtins.readFile ../modules/users/keys/mihai-io.pub;
  mihai-ganymede = builtins.readFile ../modules/users/keys/mihai-ganymede.pub;

  users = [
    mihai-io
    mihai-ganymede
  ];

  germanium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH59Ji3FQo4DkTW9knLuXpX/BC7IEEfiO65CJdT7Dw2l root@germanium";
  homesv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUrerO2XIHlOUZmPly+r7d9puX8dSN6bMyypJ6zVBra root@nixos";
  toshiba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJuGwyt3x9arBCTvoh22zBAyK+SSXYOLs68d0Ti13qy root@homesv";

  servers = [
    germanium
    homesv
    toshiba
  ];
in
{
  "vaultwarden-env.age".publicKeys = users ++ [ germanium ];
  "mihai-password.age".publicKeys = users ++ servers;
  "toshiba-networks.age".publicKeys = users ++ [ toshiba ];
}
