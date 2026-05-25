{ self, ... }:
{
  flake.modules.nixos.h610m = {
    imports = with self.modules.nixos; [
      # System type
      system-workstation
      ggantiva

      steam
      bottles
    ];

    networking = {
      hostName = "h610m";
      # Needed for ZFS
      hostId = "a9b2cbfe";
    };
  };
}
