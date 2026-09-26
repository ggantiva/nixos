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
      homepage
    ];

    home-manager.users.ggantiva.imports = with self.modules.homeManager; [
      system-cli
    ];

    networking = {
      hostName = "hp705";
    };
  };
}
