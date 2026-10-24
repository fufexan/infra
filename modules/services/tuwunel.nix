{
  config,
  self,
  ...
}:
let
  inherit (config.networking) domain;
  fqdn = "matrix.${domain}";
  cfg = config.services.matrix-tuwunel.settings.global;
  upstream = "${builtins.head cfg.address}:${toString (builtins.head cfg.port)}";
in
{
  age.secrets.tuwunel-registration-token = {
    file = "${self}/secrets/tuwunel-registration-token.age";
    owner = config.services.matrix-tuwunel.user;
    mode = "400";
  };

  services.matrix-tuwunel = {
    enable = true;
    settings.global = {
      # users are @user:domain, server runs on matrix.domain
      server_name = domain;
      address = [ "127.0.0.1" ];
      port = [ 6167 ];

      # served by tuwunel at /.well-known/matrix/{client,server}
      well_known = {
        client = "https://${fqdn}";
        server = "${fqdn}:443";
      };

      trusted_servers = [
        "matrix.org"
        "privatevoid.net"
      ];

      # to create an account: set allow_registration = true, deploy, register
      # with the token (first user becomes admin), then set it back to false
      allow_registration = false;
      registration_token_file = config.age.secrets.tuwunel-registration-token.path;

      # previews are fetched by the server, which has no private IP blocklist,
      # so only exact hosts listed here (or one subdomain under them) are fetched
      url_preview_domain_explicit_allowlist = [
        # video / audio
        "youtube.com"
        "youtu.be"
        "vimeo.com"
        "twitch.tv"
        "spotify.com"
        "soundcloud.com"
        "bandcamp.com"
        # code / docs
        "github.com"
        "gitlab.com"
        "codeberg.org"
        "stackoverflow.com"
        "crates.io"
        "docs.rs"
        "nixos.org"
        "nixos.wiki"
        "matrix.org"
        "element.io"
        # reference
        "wikipedia.org"
        "archive.org"
        "imdb.com"
        # news / discussion
        "news.ycombinator.com"
        "reddit.com"
        "lwn.net"
        "phoronix.com"
        "arstechnica.com"
        # social
        "x.com"
        "goyimx.com"
        "twitter.com"
        "bsky.app"
        "mastodon.social"
        # images
        "imgur.com"
      ];
      # strip one leading label, so www.youtube.com matches youtube.com
      url_preview_check_root_domain = true;
    };
  };

  services.caddy.virtualHosts = {
    # merged with the site config from website.nix
    ${domain}.extraConfig = ''
      reverse_proxy /.well-known/matrix/* ${upstream}
    '';

    ${fqdn}.extraConfig = ''
      reverse_proxy /_matrix/* ${upstream}
      reverse_proxy /_tuwunel/* ${upstream}
    '';
  };
}
