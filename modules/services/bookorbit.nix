{
  flake.modules.nixos.bookorbit =
    { config, ... }:
    let
      subdomain = "bookorbit";
      domain = "${subdomain}.${config.constants.domain}";
      port = 7680;
      dataDir = "/var/lib/bookorbit";
      importDir = "${dataDir}/imports";
      libraryDir = "/data/media/media/books";
    in
    {
      services.bookorbit = {
        enable = true;
        group = "media";
        environment = {
          APP_DATA_PATH = dataDir;
          APP_URL = "https://${domain}";
          PORT = port;
          MIGRATION_IMPORT_ROOT = importDir;
        };

        environmentFile = config.sops.secrets.bookorbit.path;
      };

      sops.secrets.bookorbit = { };

      systemd.tmpfiles.rules = [
        "d ${libraryDir} 0775 ${config.services.bookorbit.user} ${config.services.bookorbit.group} - -"
        "d ${importDir} 0775 ${config.services.bookorbit.user} ${config.services.bookorbit.group} - -"
      ];

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          encode zstd gzip
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [
        dataDir
        "/var/lib/postgresql"
      ];
    };

  flake.modules.nixos.homepage =
    { config, lib, ... }:
    let
      subdomain = "bookorbit";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf config.services.bookorbit.enable {
      custom.homepage.services.bookorbit = {
        group = "Media";
        name = "BookOrbit";
        icon = "bookorbit.png";
        href = "https://${domain}";
        description = "Ebook & Audiobook Manager";
        siteMonitor = "https://${domain}";
        weight = 6;
      };
    };
}
