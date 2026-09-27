{
  flake.modules.nixos.caddy =
    {
      pkgs,
      config,
      ...
    }:
    {
      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
          hash = "sha256-jNV5COlQTKSJJk8gUZ3KEs8SGC8Z7Aiy5fk7/DvkXIo=";
        };

        virtualHosts."*.${config.constants.domain}".extraConfig = ''
          tls {
            dns cloudflare {env.CF_API_TOKEN}
            propagation_delay 2m
            resolvers 1.1.1.1
          }
        '';
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.secrets.cloudflare-token.path;

      sops.secrets = {
        cloudflare-token = {
          owner = config.services.caddy.user;
          group = config.services.caddy.group;
        };
      };

      custom.impermanence.root.directories = [ "/var/lib/caddy" ];
    };
}
