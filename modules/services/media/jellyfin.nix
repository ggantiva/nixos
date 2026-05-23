{
  flake.modules.nixos.jellyfin =
    let
      url = "jellyfin";

      # Placed directly in /persist to avoid errors with permissions.
      dataDir = "/persist/var/lib/jellyfin";
      cacheDir = "/persist/var/cache/jellyfin";

      user = "jellyfin";
      group = "media";
    in
    {
      services.jellyfin = {
        enable = true;
        inherit dataDir;
        inherit cacheDir;
        inherit user;
        inherit group;
      };

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @${url} host ${url}.ggantiva.com
        handle @${url}{
          reverse_proxy localhost:8096
        }
      '';
    };
}
