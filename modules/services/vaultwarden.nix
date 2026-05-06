{ self, inputs, ... }:
{
  flake.modules.nixos.vaultwarden = {
    services.vaultwarden = {
      enable = true;
      backupDir = "/data/backups/vaultwarden";
      config = {
        DOMAIN = "https://vault.ggantiva.com";
        ROCKET_PORT = 8222;
        ROCKET_ADDRESS = "0.0.0.0";

        DATA_FOLDER = "/var/lib/vaultwarden";

        WEB_VAULT_ENABLED = true;
      };
    };

    services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
      @vault host vault.ggantiva.com
      handle @vault {
        encode zstd gzip
        reverse_proxy localhost:8222
      }
    '';

    custom.impermanence.root.directories = [ "/var/lib/vaultwarden" ];
  };
}
