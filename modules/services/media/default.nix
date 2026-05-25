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
  };
}
