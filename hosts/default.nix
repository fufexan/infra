{
  inputs,
  shared_modules,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  flake.nixosConfigurations = {
    germanium = nixosSystem {
      modules =
        [
          ./germanium
          ../modules/vaultwarden.nix
          ../modules/website.nix
        ]
        ++ shared_modules;
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
