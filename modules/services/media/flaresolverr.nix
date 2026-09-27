{
  flake.modules.nixos.flaresolverr =
    { config, ... }:
    let
      port = 8191;
      subdomain = "flaresolverr";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      services.flaresolverr = {
        enable = true;
        inherit port;
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
         reverse_proxy localhost:${toString port}
        }
      '';

      custom.homepage.services.flaresolverr = {
        group = "Media";
        name = "FlareSolverr";
        icon = "flaresolverr.png";
        href = "https://${domain}";
        description = "Cloudflare Challenge Solver";
        siteMonitor = "https://${domain}";
        weight = 6;
      };
    };
}
