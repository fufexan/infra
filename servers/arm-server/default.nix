# biggest homeserver
{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    ./synapse.nix
  ];

  age.secrets.synapse-registration-shared-secret = {
    file = "${inputs.self}/secrets/synapse-registration-shared-secret.age";
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "arm-server";
}
