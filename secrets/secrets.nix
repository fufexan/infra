let
  mihai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq9Gew1rgfdIyuriJ/Ne0B8FE1s8O/U2ajErVQLUDu9 mihai@io";

  alpha = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq1Bv6xXbjFI9bZoVJWgjfLQ6Pe82OWPhA/wVESQ5Tm fufexan.net";
in {
  "vaultwarden-env.age".publicKeys = [mihai alpha];
}
