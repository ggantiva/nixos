{
  flake.modules.nixos.calibre-web-automated =
    { config, ... }:
    let
      port = 8083;
      subdomain = "calibre";
      domain = "${subdomain}.${config.constants.domain}";
      dataDir = "/var/lib/calibre-web-automated";
      libraryDir = "/data/calibre/library";
      ingestDir = "/data/calibre/ingest";
      user = "calibre";
      group = "media";
    in
    {
      virtualisation.oci-containers.containers = {
        "calibre-web-automated" = {
          image = "docker://crocodilestick/calibre-web-automated:latest";
          environment = {
            "PGID" = toString config.users.users.${user}.uid;
            "PUID" = toString config.users.groups.${group}.gid;
            "TZ" = config.time.timeZone;
          };

          volumes = [
            "${dataDir}/config:/config"
            "${ingestDir}:/cwa-book-ingest"
            "${libraryDir}:/calibre-library"
            "${dataDir}/plugins:/config/.config/calibre/plugins"
          ];

          ports = [
            "${toString port}:8083/tcp"
          ];
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      systemd.tmpfiles.rules = [
        "d ${ingestDir} 0770 ${user} ${group} -"
        "d ${dataDir}/config 0770 ${user} ${group} -"
        "d ${libraryDir} 0770 ${user} ${group} -"
        "d ${dataDir}/plugins 0770 ${user} ${group} -"
      ];

      users.users = {
        ${user} = {
          isSystemUser = true;
          group = group;
        };
      };

      users.groups = {
        ${group} = { };
      };

      custom.impermanence.root.directories = [
        "/var/lib/calibre-web-automated"
        "/var/lib/containers"
      ];
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
