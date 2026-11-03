{
  flake.modules.nixos.prometheus =
    { config, ... }:
    let
      port = 9090;
      stateDir = "prometheus2";
      subdomain = "prometheus";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      services.prometheus = {
        enable = true;
        inherit port;
        inherit stateDir;
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';
      custom.impermanence.root.directories = [ stateDir ];
    };
}
