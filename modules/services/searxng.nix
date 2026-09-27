{
  flake.modules.nixos.searx =
    { config, ... }:
    let
      port = 8888;
      subdomain = "searx";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      services.searx = {
        enable = true;
        environmentFile = config.sops.secrets.searx-key.path;
        settings = {
          general = {
            enable_metrics = false;
          };

          server = {
            inherit port;
            secret_key = "@SEARX_SECRET_KEY@";
          };

          outgoing = {
            request_timeout = 5.0;
            max_request_timeout = 15.0;
          };

          ui.query_in_title = true;

          search = {
            safe_search = 2;
            autocomplete = "google";
            default_lang = "es-CO";
            favicon_resolver = "google";
          };

          # engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
          # };

          enabled_plugins = [
            "Basic Calculator"
            "Unit converter plugin"
            "Self Information"
            "Open Access DOI rewrite"
            "Tracker URL remover"
          ];
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      sops.secrets.searx-key = { };
    };

  flake.modules.nixos.homepage =
    { config, lib, ... }:
    let
      subdomain = "searx";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf config.services.searx.enable {
      custom.homepage = {
        services.searxng = {
          group = "Utilities";
          name = "SearXNG";
          icon = "searxng.png";
          href = "https://${domain}";
          description = "Metasearch Engine";
          siteMonitor = "https://${domain}";
        };

        widgets = [
          {
            search = {
              provider = "custom";
              url = "https://${domain}/search?q=";
              target = "_blank";
            };
          }
        ];
      };
    };
}
