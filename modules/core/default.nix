{
  inputs,
  pkgs,
  lib,
  ...
}:
# configuration shared by all hosts
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.srvos.nixosModules.server
    ./nix.nix
    ./security.nix
    ./users.nix
  ];

  environment.systemPackages = [ pkgs.helix ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  networking.domain = "fufexan.net";

  programs.vim.defaultEditor = false;

  system.stateVersion = lib.mkDefault "23.11";

  zramSwap.enable = true;
}
