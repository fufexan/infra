{
  inputs,
  shared_modules,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  flake.nixosConfigurations = {
    alpha = nixosSystem {
      modules =
        [
          ./alpha
          ../modules/vaultwarden.nix
        ]
        ++ shared_modules;
    };

    eta = nixosSystem {
      modules =
        [./eta]
        ++ shared_modules;

      system = "x86_64-linux";
    };

    homesv = nixosSystem {
      modules =
        [./homesv]
        ++ shared_modules;

      system = "x86_64-linux";
    };
  };
}
