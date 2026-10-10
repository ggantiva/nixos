{ self, ... }:
{
  flake.modules.nixos.h610m = {
    imports = with self.modules.nixos; [
      # System type
      system-workstation
      ggantiva

      steam
    ];

    home-manager.users.ggantiva.imports = with self.modules.homeManager; [
      system-workstation
    ];

    networking = {
      hostName = "h610m";
    };
  };
}
