{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        # Adapted from https://github.com/strideynet/nixos-caddy-patched
        caddy-with-plugins = pkgs.callPackage ./caddy-with-plugins { };
      };
    };
}
