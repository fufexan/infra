{
  self,
  config,
  pkgs,
  ...
}:
{
  age.secrets.immich = {
    file = "${self}/secrets/immich.age";
    owner = config.services.immich.user;
    mode = "400";
  };

  # toshiba has a Sandy Bridge iGPU, which only the legacy i965 VAAPI driver supports
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.intel-vaapi-driver ];
  };

  services.immich = {
    enable = true;

    # All interfaces
    host = "";
    # Give access to all devices
    accelerationDevices = null;
    openFirewall = true;
    secretsFile = config.age.secrets.immich.path;

    settings = {
      ffmpeg = {
        accel = "vaapi";
        transcode = "required";
      };
      server.externalDomain = "https://immich.fufexan.net";
    };
  };
}
