{
  flake.modules.nixos.miniflux =
    { config, ... }:
    let
      port = 8070;
      subdomain = "rss";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      services = {
        miniflux = {
          enable = true;
          config = {
            PORT = toString port;
          };
          adminCredentialsFile = config.sops.secrets.miniflux-creds.path;
        };

        caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
          @${subdomain} host ${domain}
          handle @${subdomain} {
            reverse_proxy localhost:${toString port}
          }
        '';
      };

      custom.homepage.services.miniflux = {
        group = "Utilities";
        name = "Miniflux";
        icon = "miniflux.png";
        href = "https://${domain}";
        description = "RSS Feed Reader";
        siteMonitor = "https://${domain}";
      };

      sops.secrets.miniflux-creds = { };

      custom.impermanence.root.directories = [ "/var/lib/postgresql" ];
    };
}
