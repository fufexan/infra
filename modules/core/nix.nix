{
  config,
  inputs,
  lib,
  ...
}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = let
      flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
    in
      lib.mapAttrs (_: v: {flake = v;}) flakeInputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings = {
      auto-optimise-store = true;
      flake-registry = "/etc/nix/registry.json";
      trusted-users = ["root" "@wheel"];
    };
  };
}
