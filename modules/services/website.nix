{
  services.caddy.virtualHosts = {
    "fufexan.net".extraConfig = ''
      encode zstd gzip
      root * /var/www/fufexan.net
      file_server

      handle_errors {
        @404 {
          expression {http.error.status_code} == 404
        }

        rewrite @404 /404.html
        file_server
      }
    '';

    "cv.fufexan.net".extraConfig = ''
      redir https://github.com/fufexan/cv
    '';

    "dots.fufexan.net".extraConfig = ''
      redir https://github.com/fufexan/dotfiles
    '';
  };
}
