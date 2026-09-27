{
  flake.modules.nixos.sonarr =
    { config, ... }:
    let
      port = 8989;
      subdomain = "sonarr";
      domain = "${subdomain}.${config.constants.domain}";
      user = "sonarr";
      group = "media";
    in
    {
      services.sonarr = {
        enable = true;
        inherit user;
        inherit group;
        settings = {
          server = {
            inherit port;
          };
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ "/var/lib/sonarr/.config/NzbDrone" ];
    };

  flake.modules.nixos.homepage =
    { config, lib, ... }:
    let
      subdomain = "sonarr";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf config.services.sonarr.enable {
      sops.secrets.homepage-sonarr = { };

      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-sonarr.path ];

        services.sonarr = {
          group = "Media";
          name = "Sonarr";
          icon = "sonarr.png";
          href = "https://${domain}";
          description = "TV Series Tracker";
          siteMonitor = "https://${domain}";
          weight = 2;
          widget = {
            type = "sonarr";
            url = "https://${domain}";
            key = "{{HOMEPAGE_VAR_SONARR_KEY}}";
          };
        };
      };
    };
}
