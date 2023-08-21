{inputs, ...}: let
  sharedModules = [
    {_module.args = {inherit inputs;};}
    ../modules/default.nix
    ../modules/security.nix
    inputs.agenix.nixosModules.default
  ];

  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  flake.nixosConfigurations = {
    alpha = nixosSystem {
      modules =
        [
          ./alpha
          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
        ]
        ++ sharedModules;
    };

    eta = nixosSystem {
      modules =
        [./eta]
        ++ sharedModules;

      system = "x86_64-linux";
    };

    homesv = nixosSystem {
      modules =
        [./homesv]
        ++ sharedModules;

      system = "x86_64-linux";
    };
  };
}
