{
  flake.modules.nixos.miniflux =
    { config, ... }:
    let
      port = 8070;
    in
    {
      services = {
        miniflux = {
          enable = true;
          config = {
            PORT = 8070;
          };
          adminCredentialsFile = config.sops.secrets.miniflux-creds.path;
        };

        caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
          @miniflux host rss.ggantiva.com
            handle @miniflux {
              reverse_proxy localhost:${toString port}
            }
        '';
      };

      sops.secrets.miniflux-creds = { };

      custom.impermanence.root.directories = [ "/var/lib/postgresql" ];
    };
}
