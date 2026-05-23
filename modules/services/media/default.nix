{ self, ... }:
{
  flake.modules.nixos.mediaServer = {
    imports = with self.modules.nixos.mediaServer; [
      qbittorrent
      jellyfin
      sonarr
      prowlarr
    ];

    users.groups.media = { };
  };
}
