{
  flake.modules.nixos.jellyfin =
    { config, ... }:
    let
      port = 8096;
      subdomain = "jellyfin";
      domain = "${subdomain}.${config.constants.domain}";

      # Placed directly in /persist to avoid errors with permissions.
      dataDir = "/persist/var/lib/jellyfin";
      cacheDir = "/persist/var/cache/jellyfin";

      user = "jellyfin";
      group = "media";
    in
    {
      services.jellyfin = {
        enable = true;
        inherit dataDir;
        inherit cacheDir;
        inherit user;
        inherit group;
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      sops.secrets.homepage-jellyfin = { };

      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-jellyfin.path ];

        services.jellyfin = {
          group = "Media";
          name = "Jellyfin";
          icon = "jellyfin.png";
          href = "https://${domain}";
          description = "Media Streaming Server";
          siteMonitor = "https://${domain}";
          weight = 1;
          widget = {
            type = "jellyfin";
            version = 2;
            url = "https://${domain}";
            key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
            enableBlocks = true;
            enableNowPlaying = false;
          };
        };
      };
    };
}
