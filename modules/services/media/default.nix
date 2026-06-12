{ self, ... }:
{
  flake.modules.nixos.media-server = {
    imports = with self.modules.nixos; [
      qbittorrent
      jellyfin
      sonarr
      radarr
      prowlarr
    ];

    users.groups.media = { };
    systemd.tmpfiles.rules = [
      "d /data/media 0770 admin media"
    ];
  };
}
