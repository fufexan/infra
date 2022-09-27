{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    pkgs = nixpkgs.legacyPackages;
    genSystems = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
  in {
    deploy = import ./servers/deploy.nix inputs;

    # nixos-configs
    nixosConfigurations = import ./servers inputs;

    devShells = genSystems (system: {
      default = pkgs.${system}.mkShell {
        buildInputs = with pkgs.${system}; [
          oci-cli
          sops
          terraform
          terraform-ls
        ];
      };
    });
  };
}
