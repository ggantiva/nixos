{
  flake.modules.nixos.radarr =
    let
      port = 9898;
      url = "radarr";
      user = "radarr";
      group = "media";
    in
    {
      services.radarr = {
        enable = true;
        inherit user;
        inherit group;
        settings = {
          server = {
            inherit port;
          };
        };
      };

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @${url} host ${url}.ggantiva.com
        handle @${url} {
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ "/var/lib/radarr/.config/NzbDrone" ];
    };
}
