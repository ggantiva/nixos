{
  flake.modules.nixos.home-assistant =
    { config, pkgs, ... }:
    let
      subdomain = "hass";
      domain = "${subdomain}.${config.constants.domain}";
      port = 8123;
    in
    {
      services.home-assistant = {
        enable = true;
        config = {
          default_config = { };
          http = {
            server_host = "127.0.0.1";
            server_port = port;
            use_x_forwarded_for = true;
            trusted_proxies = [
              "127.0.0.1"
            ];
          };
          # Allow creation of Automations, Scenes, and Scripts from the UI
          # Keep in mind these files must exist. Otherwise HA will run in recovery mode
          "automation ui" = "!include automations.yaml";
          # "scene ui" = "!include scenes.yaml";
          # "script ui" = "!include scripts.yaml";
        };

        extraComponents = [
          "analytics"
          "google_translate"
          "met"
          "radio_browser"
          "shopping_list"
          "isal"
          "tuya"
        ];

        customComponents = [
          pkgs.home-assistant-custom-components.tuya_local
        ];
      };

      services.caddy.virtualHosts = {
        "*.${config.constants.domain}".extraConfig = ''
          @${subdomain} host ${domain}
          handle @${subdomain} {
            reverse_proxy 127.0.0.1:${toString port}
          }
        '';

        # Expose home-assistant on port 8443
        "${domain}:8443".extraConfig = ''
          tls {
            dns cloudflare {env.CF_API_TOKEN}
            propagation_delay 2m
            resolvers 1.1.1.1
          }

          reverse_proxy 127.0.0.1:${toString port}
        '';
      };

      networking.firewall.allowedTCPPorts = [ 8443 ];

      custom.impermanence.root.directories = [ config.services.home-assistant.configDir ];
    };
  flake.modules.nixos.homepage =
    { config, lib, ... }:
    let
      subdomain = "vault";
      domain = "${subdomain}.${config.constants.domain}";
    in
    lib.mkIf config.services.home-assistant.enable {
      custom.homepage.services.home-assistant = {
        group = "Utilities";
        name = "Home Assistant";
        icon = "home-assistant.png";
        href = "https://${domain}";
        description = "Home Automation";
        siteMonitor = "https://${domain}";
      };
    };
}
