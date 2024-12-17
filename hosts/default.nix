{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mod = "${self}/modules";
  specialArgs = {inherit inputs self;};
in {
  flake.nixosConfigurations = {
    germanium = nixosSystem {
      inherit specialArgs;
      modules = [
        ./germanium
        mod
        "${mod}/networking"
        "${mod}/services/caddy.nix"
        "${mod}/services/soju.nix"
        "${mod}/services/vaultwarden.nix"
        "${mod}/services/website.nix"
      ];
    };

    homesv = nixosSystem {
      inherit specialArgs;
      modules = [
        ./homesv
        mod
        "${mod}/networking"
        "${mod}/services/samba.nix"
      ];
    };
  };
}
