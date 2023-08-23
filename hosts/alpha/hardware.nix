{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices = {
    disk.sda = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "0";
            end = "1GiB";
            fs-type = "fat32";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "nix";
            start = "1GiB";
            end = "100%";
            part-type = "primary";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/nix";
            };
          }
        ];
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=3G"
        "defaults"
        "mode=755"
      ];
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;
  };
}
