let
  mihai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq9Gew1rgfdIyuriJ/Ne0B8FE1s8O/U2ajErVQLUDu9 mihai@io";

  germanium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH59Ji3FQo4DkTW9knLuXpX/BC7IEEfiO65CJdT7Dw2l root@germanium";
in {
  "vaultwarden-env.age".publicKeys = [mihai germanium];
}
