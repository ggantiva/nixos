{ self, ... }:
{
  flake.modules.nixos.media-server =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        qbittorrent
        jellyfin
        sonarr
        radarr
        prowlarr
        flaresolverr
      ];

      users.groups.media = { };
      systemd.tmpfiles.rules = [
        "d /data/media 0770 ${config.constants.user} media"
      ];
    };
}
