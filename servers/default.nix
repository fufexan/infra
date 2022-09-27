inputs: let
  sharedModules = [
    {_module.args = {inherit inputs;};}
    ../modules/default.nix
    ../modules/security.nix
    inputs.agenix.nixosModule
  ];

  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  arm-server = nixosSystem {
    modules =
      [./arm-server]
      ++ sharedModules;

    system = "aarch64-linux";
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
}
