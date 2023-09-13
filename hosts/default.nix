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
          ../modules/website.nix
          inputs.srvos.nixosModules.mixins-nginx
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
        [
          ./homesv
          ../modules/samba.nix
        ]
        ++ shared_modules;

      system = "x86_64-linux";
    };
  };
}
