{ config, ... }:
let
  domain = config.networking.domain;
in
{
  services.caddy.virtualHosts = {
    ${domain}.extraConfig = ''
      encode zstd gzip
      root * /var/www/${domain}
      file_server

      handle_errors {
        @404 {
          expression {http.error.status_code} == 404
        }

        rewrite @404 /404.html
        file_server
      }
    '';

    "cv.${domain}".extraConfig = ''
      redir https://github.com/fufexan/cv
    '';

    "dots.${domain}".extraConfig = ''
      redir https://github.com/fufexan/dotfiles
    '';
  };
}
