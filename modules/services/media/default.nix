{ self, ... }:
{
  flake.modules.nixos.mediaServer = {
    imports = with self.modules.nixos; [
      qbittorrent
      jellyfin
      sonarr
      prowlarr
    ];

    users.groups.media = { };
    systemd.tmpfiles.rules = [
      "d /data/media 0770 admin media"
    ];
  };
}
