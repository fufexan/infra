{
  networking.firewall.trustedInterfaces = [ "docker0" ];

  virtualisation = {
    oci-containers.backend = "docker";
    docker.enable = true;
  };
}
