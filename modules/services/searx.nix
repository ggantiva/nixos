{
  flake.modules.nixos.searx =
    { config, ... }:
    {
      services.searx = {
        enable = true;
        environmentFile = config.sops.secrets.searx-key.path;
        settings = {
          general = {
            enable_metrics = false;
          };

          server = {
            method = "GET";
            port = 8888;
            bind_address = "0.0.0.0";
            secret_key = "@SEARX_SECRET_KEY@";
            base_url = "https://searx.ggantiva.com";
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

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @searx host searx.ggantiva.com
        handle @searx {
          reverse_proxy localhost:8888
        }
      '';

      sops.secrets.searx-key = { };
    };
}
