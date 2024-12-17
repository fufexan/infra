{
  buildGoModule,
  caddy,
}:
buildGoModule {
  pname = "caddy";
  version = "${caddy.version}-with-plugins";

  src = ./caddy-src;

  runVend = true;
  vendorHash = "sha256-/iVDqmzBW/qFNLV8tOtwhwVf15Q8pW41mNdNGo5D0yI=";

  meta.mainProgram = "caddy";
}
