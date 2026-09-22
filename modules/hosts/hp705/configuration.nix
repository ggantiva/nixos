{ self, ... }:
{
  flake.modules.nixos.hp705 = {
    imports = with self.modules.nixos; [
      system-cli
      openssh
      ggantiva

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
