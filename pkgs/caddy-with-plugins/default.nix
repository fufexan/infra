{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  caddy,
}: let
  inherit (caddy) version;
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    hash = "sha256-O4s7PhSUTXoNEIi+zYASx8AgClMC5rs7se863G6w+l0=";
  };
in
  buildGoModule {
    pname = "caddy";
    version = "${version}-with-plugins";

    src = ./caddy-src;

    runVend = true;
    vendorHash = "sha256-/iVDqmzBW/qFNLV8tOtwhwVf15Q8pW41mNdNGo5D0yI=";

    ldflags = [
      "-s"
      "-w"
      "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
    ];

    # matches upstream since v2.8.0
    tags = ["nobadger"];

    nativeBuildInputs = [installShellFiles];
    postInstall =
      ''
        install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

        substituteInPlace $out/lib/systemd/system/caddy.service \
          --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
        substituteInPlace $out/lib/systemd/system/caddy-api.service \
          --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        # Generating man pages and completions fail on cross-compilation
        # https://github.com/NixOS/nixpkgs/issues/308283

        $out/bin/caddy manpage --directory manpages
        installManPage manpages/*

        installShellCompletion --cmd caddy \
          --bash <($out/bin/caddy completion bash) \
          --fish <($out/bin/caddy completion fish) \
          --zsh <($out/bin/caddy completion zsh)
      '';

    meta =
      caddy.meta
      // {
        description = caddy.meta.description + " with plugins";
        maintainers = [lib.maintainers.fufexan];
      };
  }
