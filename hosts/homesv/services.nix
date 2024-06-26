# server services
{
  services.syncthing = {
    enable = true;
    user = "mihai";
    group = "users";
    dataDir = "/media/Syncthing";
    guiAddress = ":8384";
    openDefaultPorts = true;
  };

  services.transmission = {
    enable = true;
    user = "mihai";
    group = "users";
    home = "/media/Torrents";
    openFirewall = true;
    openRPCPort = true;

    settings = {
      rpc-bind-address = "0.0.0.0";
      # allow connecting from LAN or Tailscale
      rpc-whitelist = "127.0.0.1,192.168.*,100.*";
      rpc-host-whitelist = "homesv,homesv.local";
    };
  };
}
