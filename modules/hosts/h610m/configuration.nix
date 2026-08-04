{ self, ... }:
{
  flake.modules.nixos.h610m = {
    imports = with self.modules.nixos; [
      # System type
      system-workstation
      ggantiva

      steam
    ];

    networking = {
      hostName = "h610m";
      useNetworkd = true;
    };
  };
}
