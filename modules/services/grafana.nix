{ self, ... }:
{
  flake.modules.nixos.grafana =
    { config, ... }:
    let
      port = 3000;
      subdomain = "grafana";
      domain = "${subdomain}.${config.constants.domain}";
      dataDir = "/var/lib/grafana";
    in
    {
      imports = with self.modules.nixos; [
        prometheus
      ];

      services.grafana = {
        enable = true;
        settings = {
          analytics.reporting_enabled = false;
          users.allow_sign_up = false;
          server = {
            http_port = port;
            http_addr = "127.0.0.1";
            enforce_domain = true;
            enable_gzip = true;
            domain = domain;
          };

          security = {
            secret_key = "$__file{${config.sops.secrets."grafana/secret-key".path}}";
            admin_password = "$__file{${config.sops.secrets."grafana/admin-passwd".path}}";
            cookie_secure = true;
            disable_gravatar = true;
            hide_version = true;
          };
        };

        provision = {
          enable = true;

          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "https://prometheus.${config.constants.domain}";
              isDefault = true;
              editable = false;
            }
          ];
        };
      };

      sops.secrets = {
        "grafana/secret-key" = {
          owner = "grafana";
          group = "grafana";
          mode = "0700";
        };

        "grafana/admin-passwd" = {
          owner = "grafana";
          group = "grafana";
          mode = "0700";
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ dataDir ];
    };
}
