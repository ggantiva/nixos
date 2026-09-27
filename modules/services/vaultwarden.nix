{
  flake.modules.nixos.vaultwarden =
    { config, ... }:
    let
      port = 8222;
      subdomain = "vault";
      domain = "${subdomain}.${config.constants.domain}";
    in
    {
      services.vaultwarden = {
        enable = true;
        backupDir = "/data/backups/vaultwarden";
        config = {
          DOMAIN = "https://${domain}";
          ROCKET_PORT = port;
          DATA_FOLDER = "/var/lib/vaultwarden";
          WEB_VAULT_ENABLED = true;
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          encode zstd gzip
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.homepage.services.vaultwarden = {
        group = "Utilities";
        name = "Vaultwarden";
        icon = "vaultwarden.png";
        href = "https://${domain}";
        description = "Password Manager";
        siteMonitor = "https://${domain}";
      };

      custom.impermanence.root.directories = [ "/var/lib/vaultwarden" ];
    };
}
