{
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
}
