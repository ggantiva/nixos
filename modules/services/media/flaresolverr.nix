{
  flake.modules.nixos.flaresolverr =
    let
      port = 8191;
      url = "flaresolverr";
    in
    {
      services.flaresolverr = {
        enable = true;
      };

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @${url} host ${url}.ggantiva.com
        handle @${url} {
         reverse_proxy localhost:${toString port}
        }
      '';

      # custom.impermanence.root.directories = [ "/var/lib/sonarr/.config/NzbDrone" ];
    };
}
