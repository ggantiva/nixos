{ self, inputs, ... }:
{
  flake.modules.nixos.caddy =
    { pkgs, config, ... }:
    {
      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
          hash = "sha256-B5xXld1+IRUAQHm8zkHFqvRp8cqnervVL6XEos5VNkc=";
        };

        virtualHosts."*.ggantiva.com".extraConfig = ''
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

      custom.system.impermanence.root.directories = [ "/var/lib/caddy" ];
    };
}
