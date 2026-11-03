{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  python3,
  makeWrapper,
}:
buildNpmPackage (finalAttrs: {
  pname = "legacy-proxy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bulwarkmail";
    repo = "legacy-proxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3O0gBhay3aIVlBi6rndqv5f4PfoHlx3B9Pn4zvpEiWM=";
  };

  nodejs = nodejs_22;
  npmDepsHash = "sha256-JEljl3JzqkCG1Rwk3L9w8tVu0Pi947GPKroeS/vxKPQ=";

  # better-sqlite3 compiles a native addon with node-gyp
  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  # tsc emits dist/, the runtime needs dist/ and node_modules/ only
  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-audit --no-fund
    mkdir -p $out/lib/legacy-proxy $out/bin
    # drop better-sqlite3 build intermediates
    rm -rf node_modules/better-sqlite3/{deps,src} node_modules/better-sqlite3/build/{Release/obj.target,deps}
    cp -r dist node_modules package.json $out/lib/legacy-proxy/
    makeWrapper ${lib.getExe nodejs_22} $out/bin/legacy-proxy \
      --add-flags $out/lib/legacy-proxy/dist/server.js

    runHook postInstall
  '';

  meta = {
    description = "JMAP gateway in front of IMAP, SMTP, ManageSieve and CardDAV servers";
    homepage = "https://github.com/bulwarkmail/legacy-proxy";
    license = lib.licenses.agpl3Only;
    mainProgram = "legacy-proxy";
  };
})
