{
  flake.modules.nixos.shelfmark =
    { config, lib, ... }:
    let
      port = 8084;
      subdomain = "shelfmark";
      domain = "${subdomain}.${config.constants.domain}";
      user = "shelfmark";
      group = "shelfmark";
      ingestDir = "/data/calibre/ingest";
    in
    {
      services.shelfmark = {
        enable = true;
        environment = {
          FLASK_PORT = port;
          TZ = config.time.timeZone;
        };
      };

      systemd.services.shelfmark.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = user;
        Group = group;
        ReadWritePaths = [ ingestDir ];
        UMask = lib.mkForce "0022";
        PrivateUsers = lib.mkForce false;
      };

      users.users.${user} = {
        isSystemUser = true;
        inherit group;
        extraGroups = [ "media" ];
      };

      users.groups.${group} = { };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ "/var/lib/shelfmark" ];
    };

  flake.modules.nixos.homepage =
    { config, lib, ... }:
    let
      subdomain = "shelfmark";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf config.services.shelfmark.enable {
      custom.homepage = {
        services.shelfmark = {
          group = "Media";
          name = "Shelfmark";
          icon = "shelfmark.png";
          href = "https://${domain}";
          description = "Book and Audiobook Downloader";
          siteMonitor = "https://${domain}";
          weight = 7;
        };
      };
    };
}
