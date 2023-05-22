inputs: let
  sharedModules = [
    {_module.args = {inherit inputs;};}
    ../modules/default.nix
    ../modules/security.nix
    inputs.agenix.nixosModules.default
  ];

  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  arm-server = nixosSystem {
    modules =
      [
        ./arm-server
        {
          _module.args.nixinate = {
            host = "arm-server";
            sshUser = "mihai";
            buildOn = "remote"; # valid args are "local" or "remote"
            substituteOnTarget = false; # if buildOn is "local" then it will substitute on the target, "-s"
            hermetic = false;
          };
        }
      ]
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
