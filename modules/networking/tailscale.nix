{
  lib,
  pkgs,
  ...
}: {
  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking.firewall.trustedInterfaces = ["tailscale0"];

  # inter-machine VPN
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services = {
    networkd-dispatcher = {
      enable = true;
      rules."50-tailscale" = {
        onState = ["routable"];
        script = ''
          NETDEV="$(ip -o route get 8.8.8.8 | cut -f 5 -d ' ')"
          ${lib.getExe pkgs.ethtool} -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };
}
