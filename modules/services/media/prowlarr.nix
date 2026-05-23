{
  flake.modules.nixos.prowlarr =
    let
      port = 8989;
      url = "sonarr";
      user = "sonarr";
      group = "media";
    in
    {
      services.sonarr = {
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

      custom.impermanence.root.directories = [ "/var/lib/sonarr/.config/NzbDrone" ];
    };
}
