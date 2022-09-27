{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages;
    genSystems = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
  in {
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
