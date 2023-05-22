{
  pkgs,
  lib,
  inputs,
  ...
}:
# configuration shared by all hosts
{
  boot.tmp.cleanOnBoot = true;

  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  environment = {
    # set channels
    etc = {
      "nix/flake-channels/system".source = inputs.self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  networking = {
    firewall.checkReversePath = "loose";
    networkmanager.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes

      keep-outputs = true
      keep-derivations = true

      flake-registry = /etc/nix/registry.json
    '';

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

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings.UseDns = true;
    };

    tailscale.enable = true;
  };

  system.stateVersion = lib.mkDefault "21.11";

  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };

  time.timeZone = lib.mkDefault "Europe/Berlin";

  users.users.admin = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRDsoSresP7/VnrQOYsWWO/5V+EdPEx5PwI0DxW9H00 root@io"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYe25Lbgm8IuhOLO5fPSVtJK+avw48yIq/rE1bOb7dl mihai@io"
  ];

  zramSwap.enable = true;
}
