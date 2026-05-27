{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mod = "${self}/modules";
  specialArgs = { inherit inputs self; };
in
{
  flake.nixosConfigurations = {
    germanium = nixosSystem {
      inherit specialArgs;
      modules = [
        ./germanium
        mod
        inputs.srvos.nixosModules.hardware-hetzner-cloud
        inputs.srvos.nixosModules.mixins-terminfo
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
        inputs.srvos.nixosModules.mixins-mdns
        inputs.srvos.nixosModules.mixins-terminfo
        "${mod}/networking"
        "${mod}/services/samba.nix"
      ];
    };

    toshiba = nixosSystem {
      inherit specialArgs;
      modules = [
        ./toshiba
        mod
        inputs.srvos.nixosModules.mixins-mdns
        inputs.srvos.nixosModules.mixins-terminfo
        "${mod}/networking"
        "${mod}/services/samba.nix"
      ];
    };
  };
}
