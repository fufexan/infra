inputs: {
  nodes = with inputs.deploy-rs.lib.x86_64-linux; {
    arm-server = {
      hostname = "arm-server";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.arm-server;
      };
      sshOpts = ["-i" "/etc/ssh/ssh_host_ed25519_key"];
      sshUser = "root";
    };
    eta = {
      hostname = "eta";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.eta;
      };
      sshOpts = ["-i" "/etc/ssh/ssh_host_ed25519_key"];
      sshUser = "root";
    };
    homesv = {
      hostname = "homesv";
      profiles.system = {
        user = "root";
        path = activate.nixos inputs.self.nixosConfigurations.homesv;
      };
    };
  };
}
