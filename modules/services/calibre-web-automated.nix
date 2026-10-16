{ self, ... }:
{
  flake.modules.nixos.calibre-web-automated =
    { config, ... }:
    let
      dataDir = "/var/lib/cwa";
      configDir = "${dataDir}/config";
      ingestDir = "${dataDir}/ingest";
      port = 8083;
      gid = toString config.users.groups.media.gid;

      libraryDir = "/data/media/media/books/";

      subdomain = "calibre";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      imports = with self.modules.nixos; [ podman ];
      virtualisation.oci-containers.containers = {
        "calibre-web-automated" = {
          image = "crocodilestick/calibre-web-automated:latest";
          environment = {
            PUID = "1000";
            PGID = gid;
            TZ = config.time.timeZone;
          };

          volumes = [
            "${configDir}:/config"
            "${ingestDir}:/cwa-book-ingest"
            "${libraryDir}:/calibre-library"
          ];

          ports = [ "${toString port}:8083" ];
        };
      };

      systemd.tmpfiles.rules = [
        "d ${dataDir}    0755 1000 ${gid} - -"
        "d ${configDir}  0755 1000 ${gid} - -"
        "d ${ingestDir}  0755 1000 ${gid} - -"
        "d ${libraryDir} 0755 1000 ${gid} - -"
      ];

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ dataDir ];
    };

  flake.modules.nixos.homepage =
    { config, lib, ... }:
    let
      subdomain = "calibre";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf (config.virtualisation.oci-containers.containers ? calibre-web-automated) {
      sops.secrets.homepage-calibre = { };
      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-calibre.path ];
        services.calibre-web = {
          group = "Media";
          name = "Calibre Web";
          icon = "calibre-web.png";
          href = "https://${domain}";
          description = "Ebook Manager";
          siteMonitor = "https://${domain}";
          weight = 6;
          widget = {
            type = "calibreweb";
            url = "https://${domain}";
            username = "admin";
            password = "{{HOMEPAGE_VAR_CALIBRE_KEY}}";
          };
        };
      };
    };
}
