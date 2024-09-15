{config, ...}: {
  environment.persistence."/nix/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/nixos"
      "/tmp" # Make builds not crash by running them on disk instead of RAM (We still clean /tmp on boot)
    ];
    files =
      [
        "/etc/machine-id"
      ]
      ++ builtins.concatMap (key: [key.path (key.path + ".pub")]) config.services.openssh.hostKeys;
  };
}
