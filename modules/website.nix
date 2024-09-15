{
  services.caddy.virtualHosts."fufexan.net".extraConfig = ''
    encode zstd gzip
    root * /var/www/fufexan.net
    file_server
  '';

  services.caddy.virtualHosts."dots.fufexan.net".extraConfig = ''
    redir https://github.com/fufexan/dotfiles
  '';
}
