{
  flake.modules.nixos.radarr =
    { config, ... }:
    let
      port = 9898;
      subdomain = "radarr";
      domain = "${subdomain}.${config.constants.domain}";
      user = "radarr";
      group = "media";
    in
    {
      services.radarr = {
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

      sops.secrets.homepage-radarr = { };

      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-radarr.path ];
        services.radarr = {
          group = "Media";
          name = "Radarr";
          icon = "radarr.png";
          href = "https://${domain}";
          description = "Movie Tracker";
          siteMonitor = "https://${domain}";
          weight = 3;
          widget = {
            type = "radarr";
            url = "https://${domain}";
            key = "{{HOMEPAGE_VAR_RADARR_KEY}}";
          };
        };
      };

      custom.impermanence.root.directories = [ "/var/lib/radarr/.config/Radarr" ];
    };
}
