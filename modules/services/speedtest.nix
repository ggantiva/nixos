{
  flake.modules.nixos.speedtest =
    {
      config,
      ...
    }:
    let
      subdomain = "speedtest";
      domain = "${subdomain}.${config.constants.domain}";
      dataDir = "/var/lib/speedtest-tracker";
    in
    {
      services.speedtest-tracker = {
        enable = true;
        inherit dataDir;
        group = "caddy";
        settings = {
          APP_KEY_FILE = config.sops.secrets.speedtest-key.path;
          APP_URL = "https://${domain}";
          DB_CONNECTION = "sqlite";
          SPEEDTEST_SCHEDULE = "0 0 * * *";
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          root * ${config.services.speedtest-tracker.package}/public
          php_fastcgi unix/${config.services.phpfpm.pools.speedtest-tracker.socket}
          file_server
        }
      '';

      sops.secrets = {
        speedtest-key = {
          owner = "speedtest-tracker";
          group = "caddy";
        };
      };

      custom.impermanence.root.directories = [ dataDir ];
    };

  flake.modules.nixos.homepage =
    {
      config,
      lib,
      ...
    }:
    let
      subdomain = "speedtest";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf config.services.speedtest-tracker.enable {
      sops.secrets.homepage-speedtest = { };

      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-speedtest.path ];

        services.speedtest = {
          group = "Utilities";
          name = "Speedtest";
          icon = "speedtest-tracker.png";
          href = "https://${domain}";
          description = "Internet Performance Tracking";
          siteMonitor = "https://${domain}";
          widget = {
            type = "speedtest";
            url = "https://${domain}";
            version = 2;
            key = "{{HOMEPAGE_VAR_SPEEDTEST_KEY}}";
          };
        };
      };
    };
}
