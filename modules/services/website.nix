{ config, ... }:
let
  base = config.networking.domain;
in
{
  services.caddy.virtualHosts = {
    "${base}".extraConfig = ''
      encode zstd gzip
      root * /var/www/${base}
      file_server

      handle_errors {
        @404 {
          expression {http.error.status_code} == 404
        }

        rewrite @404 /404.html
        file_server
      }
    '';

    "cv.${base}".extraConfig = ''
      redir https://github.com/fufexan/cv
    '';

    "dots.${base}".extraConfig = ''
      redir https://github.com/fufexan/dotfiles
    '';
  };
}
