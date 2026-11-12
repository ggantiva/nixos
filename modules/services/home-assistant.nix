{
  flake.modules.nixos.home-assistant =
    { config, ... }:
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
        };

        extraComponents = [ "tuya" ];
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy 127.0.0.1:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ config.services.home-assistant.configDir ];
    };
}
