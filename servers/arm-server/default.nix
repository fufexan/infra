# biggest homeserver
{inputs, ...}: {
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

  networking.hostName = "arm-server";

  nixpkgs.config.allowUnfree = true;
}
