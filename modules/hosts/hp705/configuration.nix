{ self, ... }:
{
  flake.modules.nixos.hp705 = {
    imports = with self.modules.nixos; [
      system-base
      openssh
      admin

      project-zomboid
      media-server
      miniflux
      linkding
      caddy
      vaultwarden
      searx
    ];

    networking = {
      hostName = "hp705";
    };
  };
}
