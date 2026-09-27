{
  flake.modules.nixos.prowlarr =
    {
      config,
      lib,
      ...
    }:
    let
      port = 9696;
      subdomain = "prowlarr";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      services.prowlarr = {
        enable = true;
        settings = {
          server = {
            inherit port;
          };
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      sops.secrets.homepage-prowlarr = { };

      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-prowlarr.path ];
        services.prowlarr = {
          group = "Media";
          name = "Prowlarr";
          icon = "prowlarr.png";
          href = "https://${domain}";
          description = "Indexer Manager";
          siteMonitor = "https://${domain}";
          weight = 4;
          widget = {
            type = "prowlarr";
            url = "https://${domain}";
            key = "{{HOMEPAGE_VAR_PROWLARR_KEY}}";
          };
        };
      };

      custom.impermanence.root.directories = [ "/var/lib/private/prowlarr" ];

      # Avoids issues with permissions https://github.com/nix-community/impermanence/issues/254
      systemd.services."systemd-tmpfiles-resetup" = {
        serviceConfig = {
          RemainAfterExit = lib.mkForce false;
        };
      };
    };
}
