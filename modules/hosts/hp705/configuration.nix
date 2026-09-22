{ self, ... }:
{
  flake.modules.nixos.hp705 = {
    imports = with self.modules.nixos; [
      system-base
      openssh
      admin

      media-server
      caddy
      vaultwarden
      searx
    ];

    networking = {
      hostName = "hp705";
    };
  };
}
