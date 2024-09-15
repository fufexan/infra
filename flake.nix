{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      imports = [
        ./hosts
        ./modules
        ./pre-commit-hooks.nix
      ];

      perSystem = {
        config,
        pkgs,
        system,
        inputs',
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          name = "infra";
          packages = [
            pkgs.sops
            inputs'.agenix.packages.agenix
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    srvos = {
      url = "github:numtide/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
