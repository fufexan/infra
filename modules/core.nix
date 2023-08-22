{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}:
# configuration shared by all hosts
{
  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  environment = {
    # set channels
    etc = {
      "nix/flake-channels/system".source = self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
    };

    systemPackages = [pkgs.helix];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  programs.vim.defaultEditor = false;

  networking.firewall.checkReversePath = "loose";
  networking.domain = "fufexan.net";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    nixPath = [
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
    ];

    settings = {
      auto-optimise-store = true;

      substituters = [
        "https://nix-community.cachix.org"
        "https://fufexan.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      ];

      trusted-users = ["root" "@wheel"];
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "mihai@${config.networking.domain}";
    };
  };

  services.tailscale.enable = true;

  system.stateVersion = lib.mkDefault "23.11";

  services.getty.autologinUser = "root";

  services.openssh = {
    enable = true;
    openFirewall = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 100;
      }
    ];
  };

  users.users."mihai" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "123";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH81M2NZOzd5tGGRsDv//wkSrVNJJpaiaLghPZBH8VTd"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq9Gew1rgfdIyuriJ/Ne0B8FE1s8O/U2ajErVQLUDu9 mihai@io"
    ];
  };

  zramSwap.enable = true;
}
